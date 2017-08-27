
import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import om.Time;
import om.Tween;
import om.ease.*;

class App {

	static var target : Element;
	static var position : Dynamic;
	static var lastFrameTime : Float;

	static function animate() {
		target.style.left = position.x + 'px';
		target.style.top = position.y + 'px';
		target.style.transform = 'rotate(' + Math.floor(position.rotation) + 'deg)';
	}

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
		var now = Time.stamp();
		var delta = now - lastFrameTime;
		Tween.step( delta );
		lastFrameTime = now;
	}

	static function main() {

		window.onload = function(_) {

			position = { x:100, y:100, rotation:0 };
			target = document.getElementById( 'target' );

			var tween = new Tween( position )
				.to( { x:700, y:200, rotation:359 }, 2000 )
				.delay( 500 )
				.easing( Linear.None )
				.onUpdate( animate );

			var tweenBack = new Tween( position )
				.to( { x: 100, y: 100, rotation: 0 }, 3000 )
				.easing( Elastic.Out )
				.onUpdate( animate );
			tween.chain( [tweenBack] );
			tweenBack.chain( [tween] );

			tween.start();

			lastFrameTime = Time.stamp();
			window.requestAnimationFrame( update );
		}
	}
}
