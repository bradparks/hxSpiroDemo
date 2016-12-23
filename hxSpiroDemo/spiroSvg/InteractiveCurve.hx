package spiroSvg;
import hxSpiro.Spiro;
import hxSpiro.SpiroShapes;
import hxSpiroDemo.spiroContext.SvgPathContext;
import htmlHelper.svg.SvgPath;
import htmlHelper.svg.SvgRoot;
import js.html.Event;
import js.html.MouseEvent;
import haxe.ds.Vector;
typedef Limit = {
    var left: Float;
    var right: Float;
    var top: Float;
    var bottom: Float;
}
class InteractiveCurve {
    var svgRoot: SvgRoot;
    var arr = new Array<ControlPoint>();
    var curvePath: SvgPath; 
    var totAdded: Int = 0;
    var tot: Int = 30;
    var circles: Array<SvgPath> = [];
    var limits: Array<Limit> = [];
    public function new( svgRoot_: SvgRoot ){
        svgRoot = svgRoot_;
        curvePath = new SvgPath();
        curvePath.color = 0xFF00FF;
        curvePath.thickness = 2;
        curvePath.noFill();
    }
    public function addPoint( p: Point ){
        drawCircle( p, 6, 6, 0xFF0000 );
        var pointType: PointType;
        var last = (tot-1);
        if( totAdded == 0 ){
            pointType = OpenContour;
        } else if ( totAdded == last ){
            pointType = EndOpenContour;
        } else {
            pointType = G4;
        }
        if( totAdded < tot ){
            arr[ totAdded ] = cast { x: p.x, y: p.y, pointType: pointType };
            draw();
            totAdded++;
        } else if( totAdded == tot ){
            draw();
        }
    }
    public function checkCircle( x: Float, y: Float ){
        var aLimit: Limit;
        for( i in 0...limits.length ){
            aLimit = limits[ i ];
            if( x > aLimit.left && x < aLimit.right ){
                if( y > aLimit.top && y < aLimit.bottom ){
                    trace(' circle ' + i + ' ' + circles[ i ] );
                    return i;
                }
            }
        }
        return null;
    }
    function draw(){
        var points = new Vector<ControlPoint>( totAdded );
        var len = arr.length;
        var cp: ControlPoint;
        for( p in 0...len ) {
            cp = arr[ p ];
            points[ p ] = cast { x: cp.x, y: cp.y, pointType: cp.pointType };
        }
        points[ len - 1 ].pointType = EndOpenContour;
        var bc = new SvgPathContext();
        Spiro.taggedSpiroCPsToBezier0( points, bc );
        curvePath.path = bc.d;
        svgRoot.appendChild( curvePath );
    }
    public function redrawCircle( i: Int, x: Float, y: Float ): Void {
        var circlePath = circles[ i ];
        var point = cast { x: x, y: y };
        var points = SpiroShapes.circle( point, 6, 6 );
        var bc = new SvgPathContext();
        Spiro.spiroCPsToBezier0( points, 4, true, bc );
        circlePath.path = bc.d;
        limits[ i ] = cast { left: point.x, top: point.y, right: point.x + 6, bottom: point.y + 6 };
        arr[ i ].x = x;
        arr[ i ].y = y;
        draw();
    }
    function drawCircle( point, x: Float, y: Float, color: Int ){
        var circlePath = new SvgPath();
        circlePath.fill = color;
        var points = SpiroShapes.circle( point, x, y );
        var bc = new SvgPathContext();
        Spiro.spiroCPsToBezier0( points, 4, true, bc );
        circlePath.path = bc.d;
        svgRoot.appendChild( circlePath );
        circles.push( circlePath );
        limits.push( cast { left: point.x, top: point.y, right: point.x + x, bottom: point.y + y } );
    }
}
