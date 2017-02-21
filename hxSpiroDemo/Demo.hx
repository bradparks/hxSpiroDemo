package hxSpiroDemo;
import js.Browser;
import js.html.svg.SVGElement;
import js.html.Element;
import js.html.DivElement;
import js.html.HTMLDocument;
import js.html.svg.PathElement;
import js.html.CSSStyleDeclaration;
import hxSpiro.Spiro;
import hxSpiroDemo.spiroContext.SvgPathContext;
import hxSpiroDemo.spiroContext.CanvasPathContext;
import hxSpiroDemo.spiroContext.WebGLPathContext;
import justTriangles.PathContext;
import justTrianglesWebGL.Drawing;
import justTriangles.Triangle;
import justTriangles.Draw;
import hxSpiro.SpiroShapes;
import htmlHelper.svg.SvgRoot;
import htmlHelper.svg.SvgPath;
import js.html.Event;
import js.html.MouseEvent;
import haxe.ds.Vector;
import htmlHelper.canvas.CanvasWrapper;
import htmlHelper.canvas.Surface;
import hxSpiroDemo.spiroSvg.InteractiveCurve;
import hxSpiroDemo.spiroWebGL.CurveWebGL;
@:enum
abstract RainbowColors( Int ){
    var Violet = 0x9400D3;
    var Indigo = 0x4b0082;
    var Blue   = 0x0000FF;
    var Green  = 0x00ff00;
    var Yellow = 0xFFFF00;
    var Orange = 0xFF7F00;
    var Red    = 0xFF0000;
    var Black  = 0x000000;
}
class Demo {
    var svgRoot: SvgRoot;
    var canvas: CanvasWrapper;
    var doc: HTMLDocument;
    var buttonHolder: DivElement;
    var contentHolder: DivElement;
    var curve: InteractiveCurve;
    var curveGL: CurveWebGL;
    var webgl: Drawing;
    public static var rainbow = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet ];    
    public function new(){
        trace( 'Example of Spiro' );
        doc = Browser.document;
        contentHolder = doc.createDivElement();
        contentHolder.style.backgroundColor = '#cccccc';
        contentHolder.style.width = '1024px';
        contentHolder.style.height = '1024px';
        contentHolder.style.position = "absolute";
        contentHolder.style.zIndex = '-100';
        doc.body.appendChild( contentHolder );
        buttonHolder = doc.createDivElement();
        buttonHolder.style.zIndex = '10000';
        buttonHolder.style.position = "absolute";
        doc.body.appendChild( buttonHolder );
        createButtons();
        setupCanvas( 1024, 1024 );
        testCircleCanvas({ x: 50., y: 100. }, 100., 100.,0x0f00ff);
        setupSvg( 1024, 1024 );
        setupSvgCurve();
        setupWebGL( 1024 );
        setupCurveWebGL();
        testCircle({ x: 200., y: 100. }, 100., 100.,0xF7931E);
        //
        //testCircleWebGL({ x: 50., y: 100. }, 100., 100.,0x0f00ff);        
        //testCurve();
    }
    function createButtons(){
        var createPathBut = doc.createButtonElement();
        createPathBut.textContent = 'Create Path';
        createPathBut.addEventListener( 'mousedown', curveAllowAddPoints );
        buttonHolder.appendChild( createPathBut );
        var modifyPathBut = doc.createButtonElement();
        modifyPathBut.textContent = "Modify Points";
        modifyPathBut.addEventListener( 'mousedown', modifyPoints );
        buttonHolder.appendChild( modifyPathBut );
        
    }
    function curveAllowAddPoints( e: MouseEvent ){
        trace('curveAllowAddPoints');
        contentHolder.addEventListener( 'mousedown', addPoint );
        contentHolder.removeEventListener( 'mousedown', makePointsDragable );
    }
    function modifyPoints( e: MouseEvent ){
        trace('modifyPoints');
        contentHolder.removeEventListener( 'mousedown', addPoint );
        contentHolder.addEventListener( 'mousedown', makePointsDragable );
    }
    var circIndex: Int;
    function makePointsDragable( e: MouseEvent ){
        trace( 'checking for circle at ' + ( e.clientX - 6 ) +' '+ ( e.clientY - 6 ) );
        var i: Int = curveGL.checkCircle( e.clientX - 6, e.clientY - 6 );
        if( i != null ) {
            circIndex = i;
            contentHolder.addEventListener( 'mousemove', repositionCircle );
            contentHolder.addEventListener( 'mouseup', killMouseMove );
        }
    }
    function killMouseMove( e: MouseEvent ){
        contentHolder.removeEventListener( 'mousemove', repositionCircle );
        contentHolder.removeEventListener( 'mouseup', killMouseMove );
    }
    function repositionCircle( e: MouseEvent ){
        curveGL.redrawCircle( circIndex, e.clientX, e.clientY );
        //curve.redrawCircle( circIndex, e.clientX, e.clientY );
    }
    
    function setupSvg( wid: Int, hi: Int ){
        svgRoot = new SvgRoot();
        svgRoot.width = wid;
        svgRoot.height = hi;
        contentHolder.appendChild( svgRoot );
    }
    function setupCanvas( wid: Int, hi: Int ){
        canvas = new CanvasWrapper();
        canvas.width = 1024;
        canvas.height = 1024;
        contentHolder.appendChild( canvas );
    }
    function setupWebGL( dim: Int ){
        webgl = Drawing.create( dim );
        var dom = cast webgl.canvas;
        dom.style.setProperty("pointer-events","none");
    }    
    function setupSvgCurve(){
        curve = new InteractiveCurve( svgRoot );
    }
    function setupCurveWebGL(){
        curveGL = new CurveWebGL( webgl );
    }
    function testCircleCanvas( point, x: Float, y: Float, color: Int ){
        var points = SpiroShapes.circle( point, x, y );
        var surface: Surface = canvas.getContext2d();
        var bc = new CanvasPathContext( surface ) ;
        surface.lineStyle( 2, color, 1 );
        surface.beginFill( color, 1 );
        Spiro.spiroCPsToBezier0( points, 4, true, bc );
        surface.endFill();
    }
    function testCircleWebGL( point, x: Float, y: Float, color: Int ){
        var points = SpiroShapes.circle( point, x, y );
        var surface: Surface = canvas.getContext2d();
        var pathContext = new PathContext( 10, 300, 300 );
        var bc = new WebGLPathContext( pathContext );
        Draw.colorFill_id = 1;
        Draw.colorLine_id = 1;
        Draw.colorLine_id = 1;
        Draw.extraFill_id = 1;
        pathContext.fill = true;
        pathContext.lineType = TriangleJoinCurve; // - default
        Spiro.spiroCPsToBezier0( points, 4, true, bc );
        pathContext.render( 30, false );
        webgl.setTriangles( Triangle.triangles, cast rainbow );
    }    
    function addPoint( e: MouseEvent ){
        var p: Point =  { x: e.clientX - 3, y: e.clientY - 3 };
        curveGL.addPoint( p );
        //curve.addPoint( p );
    }
    function testCircle( point, x: Float, y: Float, color: Int ){
        var circlePath = new SvgPath();
        circlePath.fill = color;
        var points = SpiroShapes.circle( point, x, y );
        var bc = new SvgPathContext();
        Spiro.spiroCPsToBezier0( points, 4, true, bc );
        circlePath.path = bc.d;
        svgRoot.appendChild( circlePath );
    }
    function testCurve(){
        var curvePath = new SvgPath();
        curvePath.color = 0xFF00FF;
        curvePath.thickness = 2;
        curvePath.noFill();
        var points = SpiroShapes.openCurveTest( { x: 200., y: 200. }, 100., 100. );
        var bc = new SvgPathContext();
        Spiro.taggedSpiroCPsToBezier0( points, bc );
        trace( bc.d );
        curvePath.path = bc.d;
        svgRoot.appendChild( curvePath );
    }
}
