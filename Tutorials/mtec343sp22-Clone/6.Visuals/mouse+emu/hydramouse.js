/// ctrl-rtn

/// based on design by zach krall

osc(() => mouse.x / window.innerWidth * 10)
.color(0.9, 0.7, 0.8)
.diff(
  osc(45, 0.3, 100)
  .color(0.9, 0.9, 0.9)
  .rotate(0.18)
  .pixelate(12)
  .kaleid()
)
.scrollX(10)
.colorama()
.luma()
.repeatX(4)
.repeatY(4)
.modulate(
  osc(() => mouse.y / window.innerHeight * 10)
)
.scale(2)
.out()

///based on design by ojack

osc(() => mouse.y / window.innerHeight * 100)
	.rotate(0, 0.1)
	.mult(osc(10, 0.1).modulate(osc(() => mouse.x / window.innerWidth * 100).rotate(0, -0.1), 1))
	.color(2.83,0.91,0.39)
  .out(o0)
