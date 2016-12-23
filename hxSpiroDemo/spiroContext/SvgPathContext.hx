package hxSpiroDemo.spiroContext;
import hxSpiro.Spiro;// PointType
import hxSpiro.IBezierContext;
import htmlHelper.svg.SvgPathString;
class SvgPathContext implements IBezierContext {
    var sps: SvgPathString;
    var isOpen: Bool;
    public function new(){
        sps = new SvgPathString();
    }
    public var d( get, never ): String;
    public function get_d():String {
        if( isOpen ){
            sps.rtrim();
        } else {
            sps.close();
        }
        return sps;
    }
    public function moveTo( x: Float, y: Float, isOpen_: Bool ): Void {
        isOpen = isOpen_;
        sps.moveTo( x, y );
    }
    public function lineTo( x: Float, y: Float ): Void {
        sps.lineTo( x, y );
    }
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        sps.quadTo( x1, y1, x2, y2 );
    }
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        sps.curveTo( x1, y1, x2, y2, x3, y3 );
    }
    // not used ??
    public function markKnot( index: Int, theta: Float, x: Float, y: Float, type: PointType ): Void {
    }
}
