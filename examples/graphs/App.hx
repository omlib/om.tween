
import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import js.html.SpanElement;
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
            for( easeClass in easeClasses ) {
                var element = document.createDivElement();
                element.classList.add( 'group' );
                var easeClassName = Type.getClassName( easeClass );
                var easeName = easeClassName.substr( easeClassName.lastIndexOf('.')+1 );
                for( easeType in easeTypes ) {
                    if( Reflect.hasField( easeClass, easeType ) ) {
                        var graph = new Graph( easeClass, easeName, easeType );
                        element.appendChild( graph.element );
                    }
                }
                document.body.appendChild( element );
            }

            window.requestAnimationFrame( update );
        }
    }
}

private class Graph {

    public var element(default,null) : DivElement;

    public function new( easeClass : Class<Dynamic>, easeName : String, easeType : String) {

        var width = 200;
        var height = 100;
        var halfHeight = Std.int(height/2);
        var drawDuration = 500;

        element = document.createDivElement();
        element.classList.add( 'graph' );

        var title = document.createDivElement();
        title.classList.add( 'title' );
		title.textContent = '$easeName.$easeType';
		element.appendChild( title );

        var canvas = document.createCanvasElement();
        canvas.width = width;
		canvas.height = height;
        canvas.style.width = width+'px';
        canvas.style.height =  height+'px';
        element.appendChild( canvas );

        var ctx = canvas.getContext2d();

		ctx.strokeStyle = '#002B36';
        ctx.lineWidth = 1;
		ctx.beginPath();
		ctx.moveTo( 0, halfHeight );
		ctx.lineTo( width, halfHeight );
		ctx.closePath();
		ctx.stroke();

        var yIndent = 12;
		var position = { x:0, y:halfHeight };
		var position_old = { x:0, y:halfHeight };
		var easing = Reflect.field( easeClass, easeType );

        ctx.strokeStyle = '#fff';

        new Tween( position ).to( { x:width }, drawDuration ).easing( Linear.None ).start();
		new Tween( position ).to( { y: Std.int(width/2)-yIndent }, drawDuration ).easing( easing )
            .onUpdate(function(){
    			ctx.beginPath();
    			ctx.moveTo( position_old.x, position_old.y );
    			ctx.lineTo( position.x, position.y );
    			ctx.closePath();
    			ctx.stroke();
    			position_old.x = position.x;
    			position_old.y = position.y;

    		}).start();
    }
}
