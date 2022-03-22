# Real-time Synthesis

## Projects
- Sam Presentation
- Nathaniel Solo Set
- Jaxx Presentation
- Claire Solo Set

## TuningTheory from last week?

## Real-time Additive Synthesis
- **DynKlang** is a sine oscillator bank where the oscillators can be updated/modulated
<pre>
(	// create controls directly with literal arrays:
SynthDef(\dynsynth, {| freqs = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	amps = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	rings = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]|
	Out.ar(0, DynKlang.ar(`[freqs, amps, rings]))
}).add
)

(
var bufsize, ms, slid, cspec, rate;
var harmonics = 20;
GUI.qt;

x = Synth(\dynsynth).setn(
				\freqs, Array.fill(harmonics, {|i| 110*(i+1)}),
				\amps, Array.fill(harmonics, {0})
				);

// GUI :
w = Window("harmonics", Rect(200, 470, 20*harmonics+40,140)).front;
ms = MultiSliderView(w, Rect(20, 10, 20*harmonics, 110));
ms.value_(Array.fill(harmonics,0.0));
ms.isFilled_(true);
ms.indexThumbSize_(10.0);
ms.strokeColor_(Color.blue);
ms.fillColor_(Color.blue(alpha: 0.2));
ms.gap_(10);
ms.action_({
	x.setn(\amps, ms.value*harmonics.reciprocal);
});
)
</pre>

## Real-time Subtractive Synthesis
- Noise Sources:
<pre>
// WhiteNoise
{WhiteNoise.ar(0.04)}.freqscope

// PinkNoise
{PinkNoise.ar(1)}.freqscope

// BrownNoise
{BrownNoise.ar(1)}.freqscope
</pre>
- Filters:
<pre>
// low pass filter
{LPF.ar(WhiteNoise.ar(0.4), MouseX.kr(40,20000,1)!2) }.play;

// low pass filter with XLine
{LPF.ar(WhiteNoise.ar(0.4), XLine.kr(40,20000, 3, doneAction:2)!2) }.play;

// high pass filter
{HPF.ar(WhiteNoise.ar(0.4), MouseX.kr(40,20000,1)!2) }.play;

// band pass filter (the Q is controlled by the MouseY)
{BPF.ar(WhiteNoise.ar(0.4), MouseX.kr(40,20000,1), MouseY.kr(0.01,1)!2) }.play;

// Mid EQ filter attenuates or boosts a frequency band
{MidEQ.ar(WhiteNoise.ar(0.024), MouseX.kr(40,20000,1), MouseY.kr(0.01,1), 24)!2 }.play;
</pre>
- **DynKlank** is a sine oscillator bank where the oscillators are subtracted from a signal and can be updated/modulated
<pre>
/// dynklank with ggw arrays
(
SynthDef('ggw', { |out,
    amps (#[0.03, 0.3, 0.6, 1.2])|
	var freqs, env, signal;
	freqs = Array.fill(4, Pxrand([80, 106, 120, 160, 178.66, 212, 240, 268, 270.66, 282.66, 318, 360, 370.66, 406, 424, 480, 536, 541.33, 556, 636, 720, 741.33, 812, 1112], inf
	).iter);
	env = Env.sine(90, 1);
    signal = DynKlank.ar(`[freqs, amps], PinkNoise.ar([0.007,0.007]));
	Out.ar(out, signal*EnvGen.kr(env, doneAction: Done.freeSelf));
}).add;
)

a = Synth('ggw');
a.free;
</pre>
