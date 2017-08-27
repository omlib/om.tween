
import js.Browser.document;
import js.Browser.window;
import om.Time;
import om.Tween;
import om.ease.*;

class App {

	static var lastFrameTime : Float;

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
		var now = Time.stamp();
		var delta = now - lastFrameTime;
		Tween.step( delta );
		lastFrameTime = now;
	}

	static function main() {

		window.onload = function(_) {

			for( i in 0...window.innerHeight ) {

				var startValue = 500 + (Math.random() - Math.random()) * 250;
				var endValue = 500 + (Math.random() - Math.random()) * 250;

				var dom = document.createDivElement();
				var bg = Std.int( Math.random() * 0xffffff ) >> 0;
				dom.style.position = 'absolute';
				dom.style.top = (Math.random() * window.innerHeight) + 'px';
				dom.style.left = startValue + 'px';
				dom.style.background = '#' + untyped bg.toString(16);
				dom.style.width = '100px';
				dom.style.height = '2px';
				document.body.appendChild( dom );

				var elem = { x:startValue, dom:dom };
				var updateCallback = function() {
					dom.style.left = elem.x + 'px';
				}
				var tween = new Tween( elem )
					.to({ x:endValue }, 4000)
					.delay( Math.random() * 1000 )
					.easing( Back.Out )
					.onUpdate( updateCallback )
					.start();
				var tweenBack = new Tween( elem )
					.to({ x:startValue }, 4000 )
					.delay( Math.random() * 1000 )
					.easing( Elastic.InOut )
					.onUpdate( updateCallback );
				tween.chain( [tweenBack] );
				tweenBack.chain( [tween] );
			}
			
			lastFrameTime = Time.stamp();
			window.requestAnimationFrame( update );
		}
	}
}
