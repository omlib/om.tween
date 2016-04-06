
import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import js.html.SpanElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import om.Tween;
import om.easing.*;

class App {

    static function update( time : Float ) {
        window.requestAnimationFrame( update );
        Tween.step( time );
    }

    static function main() {

        window.onload = function(_){

            var easeClasses : Array<Class<Dynamic>> = [Back,Bounce,Circular,Cubic,Elastic,Exponential,Quadratic,Quartic,Quintic,Sinusoidal];
            var easeTypes = ['In','Out','InOut'];
            var graphs = new Array<Graph>();

            for( easeClass in easeClasses ) {

                var e = document.createDivElement();
                e.classList.add( 'group' );
                document.body.appendChild( e );

                var cName = Type.getClassName( easeClass );
                var name = cName.substr( cName.lastIndexOf('.')+1 );
                for( easeType in easeTypes ) {
                    if( Reflect.hasField( easeClass, easeType ) ) {
                        var g = new Graph( easeClass, name, easeType, 200, 100, 3000 );
                        graphs.push( g );
                        e.appendChild( g.element );
                        g.tween();
                    }
                }
            }

            window.requestAnimationFrame( update );

            /*
            document.body.onclick = function(){
                for( g in graphs ) g.tween();
            }
            */
        }
    }
}

private class Graph {

    public var element(default,null) : DivElement;

    var canvas : CanvasElement;
    var context : CanvasRenderingContext2D;
    var easeClass : Class<Dynamic>;
    var easeType : String;
    var drawDuration : Int;
    var tweenX : Tween;
    var tweenY : Tween;

    public function new( easeClass : Class<Dynamic>, easeName : String, easeType : String, width : Int, height : Int, drawDuration = 3000 ) {

        this.easeClass = easeClass;
        this.easeType = easeType;
        this.drawDuration = drawDuration;

        var ratio = window.devicePixelRatio;
        width = Std.int( width * ratio );
        height = Std.int( height * ratio );

        element = document.createDivElement();
        element.classList.add( 'graph' );

        var title = document.createDivElement();
        title.classList.add( 'title' );
		title.textContent = '$easeName.$easeType';
		element.appendChild( title );

        canvas = document.createCanvasElement();
        canvas.width = width;
        canvas.height = height;

        context = canvas.getContext2d();
        context.strokeStyle = '#002B36';
        context.lineWidth = 1;
        element.appendChild( canvas );

        if( ratio > 1 ) {
            var oldWidth = canvas.width;
            var oldHeight = canvas.height;
            canvas.width = Std.int( oldWidth * ratio );
            canvas.height = Std.int( oldHeight * ratio );
            canvas.style.width = oldWidth + 'px';
            canvas.style.height = oldHeight + 'px';
            canvas.getContext2d().scale( ratio, ratio );
        } else {
            canvas.style.width = width+'px';
            canvas.style.height =  height+'px';
        }
    }

    public function tween() {

        var halfHeight = Std.int( canvas.height / 2 );
        var yIndent = 12;
        var easing = Reflect.field( easeClass, easeType );
		var pos = { x: 0, y: halfHeight };
		var pos_old = { x: 0, y: halfHeight };

        context.clearRect( 0, 0, canvas.width, canvas.height );

        context.beginPath();
        context.strokeStyle = '#002B36';
        context.moveTo( 0, halfHeight );
        context.lineTo( canvas.width, halfHeight );
        context.stroke();
        context.closePath();

        context.strokeStyle = '#D33682';

        if( tweenX != null && tweenX.isPlaying ) tweenX.stop();
        if( tweenY != null && tweenY.isPlaying ) tweenY.stop();

        tweenX = new Tween( pos )
            .to( { x: canvas.width }, drawDuration )
            .easing( Linear.None )
            .start();

		tweenY = new Tween( pos )
            .to( { y: Std.int(canvas.width/2)-yIndent }, drawDuration )
            .easing( easing )
            .onUpdate( function(){
    			context.beginPath();
    			context.moveTo( pos_old.x, pos_old.y );
    			context.lineTo( pos.x, pos.y );
                context.stroke();
    			context.closePath();
    			pos_old.x = pos.x;
    			pos_old.y = pos.y;
            }).start();
    }
}
