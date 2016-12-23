package hxSpiroDemo.spiroContext;
import hxSpiro.Spiro;// PointType
import hxSpiro.IBezierContext;
import htmlHelper.canvas.Surface;
class CanvasPathContext implements IBezierContext {
    public var isOpen: Bool;
    var _surface: Surface;
    public function new( surface_: Surface ){
        _surface = surface_;
    }
    public function moveTo( x: Float, y: Float, isOpen_: Bool ): Void {
        isOpen = isOpen_;
        _surface.moveTo( x, y );
    }
    public function lineTo( x: Float, y: Float ): Void {
        _surface.lineTo( x, y );
    }
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        _surface.quadTo( x1, y1, x2, y2 );
    }
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        _surface.curveTo( x1, y1, x2, y2, x3, y3 );
    }
    // not used ??
    public function markKnot( index: Int, theta: Float, x: Float, y: Float, type: PointType ): Void {
    }
}
