
import nme.Lib;
import nme.display.Sprite;
import nme.events.Event;
import om.Time.now;
import om.Tween;
import om.easing.*;

class App {

	static var startTime : Float;
	static var target : Sprite;
	static var position : Dynamic;

	static function animate() {
		target.x = Std.int( position.x );
		target.y = Std.int( position.y );
		target.rotation = Std.int( position.rotation );
	}

	static function update(_) {
		var time = now();
		Tween.step( time );
		animate();
    }

	public static function main() {

		target = new Sprite();

		var g = target.graphics;
		g.beginFill( 0xff0000 );
		g.drawRect( -50, -50, 100, 100 );
		g.endFill();

		Lib.current.stage.addChild( target );

		position = { x:100, y:100, rotation:0, any:0 };

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

		startTime = now();
		Lib.current.stage.addEventListener( Event.ENTER_FRAME, update );

		tween.start();
	}
}
