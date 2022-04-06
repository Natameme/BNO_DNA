(
~noteArr = [
		(1),
		(5/3),
		(2),
		(5/2),

		(5/4),
		(2),
		(5/2),
		(3),

		(4/3),
		(2),
		(8/3),
		(3),

		(9/8),
		(5/3),
		(8/3),
		(5/2)
		];

r=80;
~bells.stop;
~bells= Pbind(
	\instrument, \PianoC3,
	\fFreq, Pwhite(400, 1000, inf),
	\pan, Pwhite(0, 1, inf),
	\aDec, 2,
	\dur, 0.4,
	\oFreq, Pseq(~noteArr * r
	, inf),
	\pan, 0.1,
	\aAmt, 0.08
).play;
)