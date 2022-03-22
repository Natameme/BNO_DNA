///shft-rtn

///beep + astrocade
(c = {Clip.ar((Mix(Beep.ar((0.1..5)*200+100, LFPulse.kr((0.1..5)))).dup*0.09), -1, 1)}.play);
c.free;
(a ={Mix(Astrocade.ar(MouseX.kr(0, 255), LFPulse.kr((0.1..5)*30), LFPulse.kr((0.1..5)*60), LFPulse.kr((0.1..5)*90), reg5: 2r00000111, reg6:2r01110111).dup)}.play);
a.free

///ay8910sq
(
{AY8910Square.ar(
	MouseX.kr(1, 4096, 'exponential'),
	MouseY.kr(1, 255, 'exponential'),
	SinOsc.kr(0.35, [0, pi/2], 3.5, 3.5).round
)}.play
)
///atari2600
{Atari2600.ar(MouseX.kr(0, 15), SinOsc.kr(0.35, 0, 7.5, 7.5), 10, MouseY.kr(0, 31), SinOsc.kr(0.3, 0, 5.5, 5.5), 5)*3.dup}.play


(
SynthDef(\atari2600, {|out= 0, gate= 1, tone0= 5, tone1= 8, freq0= 10, freq1= 20, rate= 1, amp= 1, pan= 0|
	var e, z;
	e= EnvGen.kr(Env.asr(0.01, amp, 0.05), gate, doneAction:2);
	z= Atari2600.ar(tone0, tone1, freq0, freq1, 15, 15, rate);
	Out.ar(out, Pan2.ar(z*e, pan));
}).add;
)

(
Pbind(
	\instrument, \atari2600,
	\dur, 0.125,
	\amp, 0.8,
	\tone0, Pseq([Pn(3, 64), Pn(2, 128), Pn(10, 8)], inf),
	\tone1, Pseq([Pn(8, 32), Pwhite(0, 15, 12)], inf),
	\freq0, Pseq([Pn(10, 17), Pn(Prand([1, 2, 3]), 4), Pn(10, 3)], inf),
	\freq1, Pseq([10, 3, Pwrand([20, 1], [0.6, 0.4])], inf)
).play
)

(
Pbind(
	\instrument, \atari2600,
	\dur, Pbrown(0.1, 0.15, 0.1),
	\amp, 0.8,
	\tone0, 1,
	\tone1, 2,
	\freq0, Pseq([24, 24, Pwrand([20, 23], [0.6, 0.4])], inf),
	\freq1, Pseq([1, 3, Pwrand([2, 1], [0.6, 0.4])], inf)
).play
)

(
Pbind(
	\instrument, \atari2600,
	\dur, Pseq([0.06, 0.04], inf),
	\amp, 0.8,
	\tone0, Pseq([10, 10, 10, 3], inf),
	\tone1, Pseq([3, 3, 3, 3, 10], inf),
	\freq0, Pseq([1, 2, 3], inf),
	\freq1, Pseq([10, 2, 13, 5], inf)
).play
)

(
Pbind(
	\instrument, \atari2600,
	\dur, Pseq([0.25, 0.25, 0.25, 0.45], inf),
	\amp, 0.8,
	\tone0, Pseq([Pseq([2, 5], 32), Pseq([3, 5], 32)], inf),
	\tone1, 14,
	\freq0, Pseq([Pbrown(28, 31, 1, 32), Pbrown(23, 26, 3, 32)], inf),
	\freq1, Pseq([Pn(10, 16), Pn(11, 16)], inf)
).play
)

(
Pbind(
	\instrument, \atari2600,
	\dur, 0.1,
	\amp, 0.8,
	\tone0, Pseq([Pseq([10, 2], 32), Pseq([1, 9], 32), Pseq([1, 2, 4], 36)], inf),
	\tone1, Pseq([Pseries(10, 14, 16), Pseries(10, 5, 16)], inf),
	\freq0, Pseq([Pseries(10, 31, 16), Pseries(27, 31, 16)], inf),
	\freq1, Pseq([Pseries(9, 31, 16), Pseries(26, 31, 16)], inf)
).play
)

(
Pbind(
	\instrument, \atari2600,
	\dur, 0.1,
	\amp, 0.8,
	\legato, 1.5,
	\tone0, 15,
	\tone1, Pseq([Pn(2, 80), Pn(3, 80), Pn(4, 80), Pn(0, 40)], inf),
	\freq0, Pseq([Pseries(5, 0.1, 40)], inf),
	\freq1, Pseq([Pseries(10, 0.05, 50)], inf),
	\rate, Pseq([Pseries(1, 1, 20)], inf)
).play
)

(
Pbind(
	\instrument, \atari2600,
	\dur, 0.1,
	\amp, 0.8,
	\legato, 1.2,
	\tone0, 15,
	\tone1, Pseq([Pn(3, 40), Pwhite(3, 10, 8).round(3)], inf),
	\freq0, Pseq([Pn(11, 128), Pn(15, 128)], inf),
	\freq1, Pseq([10, 3, Pwrand([2, 1], [0.6, 0.4])], inf),
	\rate, Pseq([Pn(1, 8), Pn(2, 8), Pn(1, 8), Pn(Pwrand([1.1, 1.5], [0.8, 0.2]), 8)], inf)
).play
)

//sn76489

(h ={SN76489.ar(MouseX.kr(0, 1023), SinOsc.kr([0.35, 0.45], 0, 7.5, 7.5), 100, MouseY.kr(0, 7).round-[0, 7], SinOsc.kr(0.3, 0, 5.5, 5.5), 5, 2, 3)}.play);
h.free;

{SN76489.ar(LFSaw.kr(0.9)<0.4*80+40, LFSaw.kr(0.9)<0.45*80+80, LFSaw.kr(0.9)<0.5*(SinOsc.kr(0.09)>0.5*80+80)+160, LFSaw.kr(4.5, 0, 3.5, 3.5), LFSaw.kr(0.3, 0, 5.5, 5.5), LFSaw.kr(0.31, 0.25, 5.5, 5.5), LFSaw.kr(0.32, 0.5, 5.5, 5.5), LFSaw.kr(1.8)>0.63*9).dup}.play

{SN76489.ar(LFPulse.kr(9, 0, 0.2, 200, 900)*[1, 1.01], LFPulse.kr(8, 0, 0.2, 200, 600)*[1, 1.01], LFPulse.kr(7, 0, 0.2, 200, 400)*[1, 1.01], 0, 15, 15, 15, 15, LFNoise0.kr(9/8/7, 0.5, 1.5).round(0.25))}.play

(
SynthDef(\sn76489, {|out= 0, gate= 1, tone0= 0, tone1= 0, tone2= 0, noise= 0, vol0= 0, vol1= 0, vol2= 0, vol3= 0, rate= 1, amp= 1, pan= 0|
	var e, z;
	e= EnvGen.kr(Env.asr(0.01, amp, 0.05), gate, doneAction:2);
	z= SN76489.ar(tone0, tone1, tone2, noise, vol0, vol1, vol2, vol3, rate);
	Out.ar(out, Pan2.ar(z*e, pan));
}).add;
)


(
Pbind(
	\instrument, \sn76489,
	\dur, 0.1,
	\amp, 0.8,
	\tone0, Pseq([Pseq([10, 2], 32), Pseq([1, 9], 32), Pseq([1, 2, 4], 36)], inf)*20,
	\tone1, Pseq([Pseries(10, 14, 16), Pseries(10, 5, 16)], inf),
	\vol0, 10,
	\vol1, 10
).play
)

(
Pbind(
	\instrument, \sn76489,
	\dur, 0.25,
	\amp, 0.8,
	\tone0, Pseq([1000, 400, 500, 800], inf),
	\vol0, 10,
	\tone1, Pseq([200, 200, 600, 80], inf),
	\vol1, Pseq([Pn(0, 16), Pn(7, 16)], inf),
	\tone2, Pseq([300, 1000, 400, 1000], inf),
	\vol2, Pseq([Pn(0, 32), Pn(5, 32)], inf),
	\noise, Pseq([3, 4, 5, 6], inf),
	\vol3, Pseq([Pn(0, 64), Pn(7, 64)], inf)
).play
)

(
Pbind(
	\instrument, \sn76489,
	\dur, Pseq([0.12, 0.08], inf),
	\amp, 0.8,
	\rate, Pseq([Pn(1, 32), Pn(0.9, 32)], inf)*Pseq([Pn(1, 128), Pn(0.5, 128)], inf),
	\tone0, Pseq([10, 10, 10, 3], inf),
	\tone1, Pseq([300, 300, 300, 300, 1000], inf),
	\tone2, Pseq([10, 2, 13, 5], inf),
	\noise, Pseq([1, 2, 3], inf),
	\vol0, Pseq([Pn(10, 10), 0, 0], inf),
	\vol1, Pseq([Pn(10, 12), 0, 0], inf),
	\vol2, Pseq([Pn(10, 14), 0, 0], inf),
	\vol3, Pseq([Pn(10, 16), 0, 0], inf)
).play
)

(
Pbind(
	\instrument, \sn76489,
	\dur, Pbrown(0.1, 0.15, 0.1),
	\amp, 1,
	\tone0, 100,
	\tone1, Pseq([Pstutter(16, Pseq([200, 220])), Prand([22, 33, 44])], inf),
	\tone2, 300,
	\vol0, Pseq([9, 9, Pwrand([12, 7], [0.4, 0.6])], inf),
	\vol1, Pseq([1, 3, Pwrand([2, 1], [0.4, 0.6])], inf),
	\vol2, Pseq([2, 1, Pwrand([3, 1], [0.4, 0.6])], inf)
).play
)

(
Pbind(
	\instrument, \sn76489,
	\dur, 0.125,
	\amp, 0.8,
	\tone0, Pseq([Pn(900, 48), Pn(860, 24), Pn(1012, 24)], inf),
	\tone1, Pseq([Pn(0, 32), Pwhite(0, 8, 12)*15], inf)+602,
	\tone2, Pseq([Pn(4, 12), Pseq([86, 87, 88], 2)], inf)*100,
	\noise, Pseq([4, 3, Pwrand([2, 1], [0.6, 0.4])], inf),
	\vol0, 12,
	\vol1, Pseq([Pseries(0, 0.04, 375), Pseq([15, 0], 7)], inf),
	\vol2, Pseq([Pser([5, 3, 0], 13), Pn(8, 6), Pn(0, 3)], inf),
	\vol3, 15
).play
)

(
Ppar([
	Pbind(\instrument, \sn76489, \dur, 0.1500, \tone0, 145, \vol0, 10, \tone1, 320, \vol1, 15),
	Pbind(\instrument, \sn76489, \dur, 0.1525, \tone0, 320, \vol0, 10, \tone1, 495, \vol1, 15),
	Pbind(\instrument, \sn76489, \dur, 0.1550, \tone0, 495, \vol0, 10, \tone1, 670, \vol1, 15),
	Pbind(\instrument, \sn76489, \dur, 0.1575, \tone0, 670, \vol0, 10, \tone1, 845, \vol1, 15),
	Pbind(\instrument, \sn76489, \dur, 0.1575, \tone0, 845, \vol0, 10, \tone1, 1020, \vol1, 15)
]).play
)