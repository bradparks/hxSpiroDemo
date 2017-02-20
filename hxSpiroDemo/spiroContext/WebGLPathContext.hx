package hxSpiroDemo.spiroContext;
import hxSpiro.Spiro;// PointType
import justTriangles.PathContext;
import hxSpiro.IBezierContext;
import htmlHelper.svg.SvgPathString;
class WebGLPathContext implements IBezierContext {
    var isOpen: Bool;
    var pathContext: PathContext;
    public function new( pathContext_: PathContext ){
        pathContext = pathContext_;
    }
    public function moveTo( x: Float, y: Float, isOpen_: Bool ): Void {
        isOpen = isOpen_;
        pathContext.moveTo( x, y );
    }
    public function lineTo( x: Float, y: Float ): Void {
        pathContext.lineTo( x, y );
    }
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        pathContext.quadTo( x1, y1, x2, y2 );
    }
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        pathContext.curveTo( x1, y1, x2, y2, x3, y3 );
    }
    // not used ??
    public function markKnot( index: Int, theta: Float, x: Float, y: Float, type: PointType ): Void {
    }
}
