(
~kickAmps = [
	1, 0, 0, 0,
	1, 0, 0, 0,
	1, 0, 0, 0,
	1, 0, 0, 0];
Pdef(\kick, Pbind(
	\instrument, \monoSamples,
	\dur, 1/4,
	\amp, Pseq(~kickAmps, inf),
)).play();
)