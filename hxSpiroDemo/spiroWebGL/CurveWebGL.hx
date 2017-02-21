package hxSpiroDemo.spiroWebGL;
import hxSpiro.Spiro;
import hxSpiro.SpiroShapes;
import justTrianglesWebGL.Drawing;
import justTriangles.Triangle;
import justTriangles.PathContext;
import hxSpiroDemo.spiroContext.WebGLPathContext;
import js.html.Event;
import js.html.MouseEvent;
import haxe.ds.Vector;
import justTriangles.Draw;
typedef Limit = {
    var left: Float;
    var right: Float;
    var top: Float;
    var bottom: Float;
}
class CurveWebGL {
    var webgl: Drawing;
    var arr = new Array<ControlPoint>();
    var totAdded: Int = 0;
    var tot: Int = 30;
    var limits: Array<Limit> = [];
    public function new( webgl_: Drawing ){
        webgl = webgl_;

    }
    public function addPoint( p: Point ){
        drawCircle( p );
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
            trace( 'i ' + i + ' ' + aLimit.left + ' ' + aLimit.top );
            trace( '    ' + aLimit.right + ' ' + aLimit.bottom );
            if( x > aLimit.left && x < aLimit.right ){
                if( y > aLimit.top && y < aLimit.bottom ){
                    trace(' circle ' + i );
                    return i;
                }
            }
        }
        return null;
    }
    function draw(){
        Triangle.triangles = new Array<Triangle>();
        var points = new Vector<ControlPoint>( totAdded );
        var len = arr.length;
        var cp: ControlPoint;
        for( p in 0...len ) {
            cp = arr[ p ];
            points[ p ] = cast { x: cp.x, y: cp.y, pointType: cp.pointType };
        }
        points[ len - 1 ].pointType = EndOpenContour;
        var pathContext = new PathContext( 2, 500 );
        var bc = new WebGLPathContext( pathContext );
        Draw.colorFill_id = 1;
        Draw.colorLine_id = 1;
        Draw.colorLine_id = 1;
        Draw.extraFill_id = 1;
        //pathContext.fill = true;
        pathContext.lineType = TriangleJoinCurve; // - default
        
        Spiro.taggedSpiroCPsToBezier0( points, bc );
        for( p in arr ){
            var point2 = cast { x: p.x, y: p.y };
            var points2 = SpiroShapes.circle( point2, 6, 6 );
            pathContext.moveTo( p.x, p.y );
            Spiro.spiroCPsToBezier0( points2, 4, true, bc );
        }
        pathContext.render(2, false );
        webgl.clearVerticesAndColors();
        webgl.setTriangles( Triangle.triangles, cast Demo.rainbow );
    }
    
    public function redrawCircle( i: Int, x: Float, y: Float ): Void {
        var point = cast { x: x, y: y };
        limits[ i ] = cast { left: point.x - 5, top: point.y - 5, right: point.x + 6 + 5, bottom: point.y + 6 + 5};
        arr[ i ].x = x;
        arr[ i ].y = y;
        draw();
    }
    function drawCircle( point: Point ){
        limits.push( cast { left: point.x - 5, top: point.y - 5, right: point.x + 6 + 5, bottom: point.y + 6 + 5} );
    }
}
