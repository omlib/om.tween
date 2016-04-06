
# OM|TWEEN

Simple tweening library.


## Usage

```haxe
new Tween( target )
    .to( { x:700, y:200, rotation:359 }, 2000 )
    .delay( 500 )
    .easing( Linear.None )
    .start();
```
See [examples/](examples/) for more complex usage.

## Easing
![EasingGraphs](easing-graphs.png)
