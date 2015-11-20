
import js.Browser.document;
import js.Browser.window;
import om.Tween;
import om.easing.*;

class App {

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
		Tween.step( time );
	}

	static function main() {

		window.onload = function(_) {

			var table = document.createTableElement();
			var index = 0;

			for( i in 0...64 ) {

				var tr = table.insertRow( -1 );

				for( j in 0...64 ) {

					var td = untyped tr.insertCell( -1 );
					td.style.background = '#000';
					var x = (i+j) * 0.1;
					var cell = { td:td, value:0 };

					var tween = new Tween( cell )
						.to( { value:1 }, 8000 )
						.delay( (0.001 * index + Math.random()) * 500 )
						.easing( Elastic.InOut )
						.onUpdate( function() {
							var c = Math.floor( cell.value * 0xff );
							td.style.background = 'rgb(' + c + ', 0, 0)';
						});

					var tweenBack = new Tween( cell )
						.to( { value:0 }, 4000 )
						.delay( (0.001*index + Math.random()) * 500 )
						.easing( Elastic.InOut )
						.onUpdate( function() {
							var c = Math.floor( cell.value * 0xff );
							td.style.background = 'rgb(' + c + ', 0, 0)';
						});
					tween.chain( [tweenBack] );
					tweenBack.chain( [tween] );

					tween.start();

					index++;
				}
			}
			document.body.appendChild( table );

			window.requestAnimationFrame( update );
		}
	}
}
