# Patterns and Envelopes

## SC Language Continued
- Conditionals and control flow
  - Comparison:
  <pre>
      >
      <
      >=
      <=
      </pre>
  - Boolean:
  <pre>
      ==
      !=
      &&
      ||
  </pre>

- Iterating and looping
  - Because SC is totally OOP, have to use an object method to iterate
  - **.do** is the most common
  <pre>
  10.do({ "SCRAMBLE THIS 10 TIMES".scramble.postln; })
  </pre>
  - **if**, **while**, and **for** also exist, but more on them later

## SC Server
- The audio engine!
- Plays well with others
- Can be booted through the command line, by other softwares, etc.
- 's' stands for server! Don't assign things to it
- useful **s.** commands
<pre>
s.makeWindow;
s.record;
s.stopRecording;
s.scope;
s.addr // the address of the synth (IP address and Port)
s.name // the localhost server is the default server (see Main.scd file)
s.serverRunning // is it running?
s.avgCPU // how much CPU is it using right now?
</pre>
- Unit Generators
  - Modular building blocks of synthesis systems
  - Think of them like modules in your synthesizer
  - They make a waveform, a filter, etc.
  - In SC they're actually written in C/C++ and are a plugin to the SC Server, but most come standard with download
  - Most have Audio Rate **.ar** and Control Rate **.kr** methods
- **SynthDef**
  - A class which pre-compiles multiple unit generators into an abstract data type called a graph and sends that data to the server via OpenSoundControl (OSC)
  - You can compound unit generators together and reuse their amalgam fixed function
  - But! You have to stop sound and refresh in server to control
  - Have to store as variable to control
  - ***Best for live synthesis***
<pre>
SynthDef(\abc, {Out.ar(0, SinOsc.ar(600))}).add;
Synth(\abc)
///
(
SynthDef(\test, {|freq= 400|
	Out.ar(0, SinOsc.ar(freq, 0, 0.1));
}).add;
)
a= Synth(\test)
a.set(\freq, 300)
a.free
b= Synth(\test)
Synth(\test, [\freq, 800])
Synth(\test, [\freq, 700])
Synth(\test, [\freq, 600])
Synth(\test, [\freq, 500])
Synth(\test, [\freq, 100])
</pre>
- **Ndefs**
  - A class which registers synths by key
  - Registered synths can be replaced by others in quantized real-time with automatic crossfades
  - Uses node proxies (placeholders for something playing on a server), much more on this later
  - ***Best for live sequencing***
<pre>
Ndef(\key, {SinOsc.ar(700)}).play
///
Ndef(\first, {SinOsc.ar(400)})
Ndef(\first).play
Ndef(\first, {|freq= 300| SinOsc.ar(freq)})
Ndef(\first, {SinOsc.ar(60.1)})
Ndef(\first).stop
Ndef(\first).play(fadeTime: 5)
Ndef(\first).stop(fadeTime: 5)
/* these examples from https://fredrikolofsson.com/code/sc/ */
</pre>

## Patterns
- Describe a process but details of the process are abstracted-out
- **PBind** is a class which binds values and keys together to control synths, passes that functionalty to a **Stream**
- There is a defult **PBind** synth, but you can also **SynthDef** your own

### Simple Patterns
  - **Pseq**
  - Goes through sequence
<pre>
(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).play;
)
</pre>
  - **Pseries**
  - Arithmetic
  - **Pgeom**
  - Geometry
<pre>
(
p = Pbind(
    \degree, Pseries(-7, 1, 15),
    \dur, Pgeom(0.5, 0.89140193218427, 15)
).play;
)
</pre>

## Randomness
  - **Prand**
  - Randomly chooses from list
<pre>
(
p = Pbind(
    \degree, Prand([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)
</pre>
  - **Pxrand**
  - "Randomly" chooses but never twice in a row
<pre>
(
p = Pbind(
    \degree, Pxrand([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)
</pre>
  - **Pshuf**
  - Shuffles the list in random order but then uses the same random order
<pre>
(
p = Pbind(
    \degree, Pshuf([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)
</pre>
  - **Pwrand**
  - Chooses "randomly" according to weighted probabilities
<pre>
(
p = Pbind(
    \degree, Pwrand((0..7), [4, 1, 3, 1, 3, 2, 1].normalizeSum, inf),
    \dur, 0.25
).play;
)
</pre>

## Probability
<pre>
Pwhite(lo, hi, length)
Produces length random numbers with equal distribution ('white' refers to white noise).
Pexprand(lo, hi, length)
Same, but the random numbers have an exponential distribution, favoring lower numbers. This is good for frequencies, and also durations (because you need more notes with a shorter duration to balance the weight of longer notes).
Pbrown(lo, hi, step, length)
Brownian motion. Each value adds a random step to the previous value, where the step has an equal distribution between -step and +step.
Pgbrown(lo, hi, step, length)
Brownian motion on a geometric scale. Each value multiplies a random step factor to the previous value.
Pbeta(lo, hi, prob1, prob2, length)
Beta distribution, where prob1 = α (alpha) and prob2 = β (beta).
Pcauchy(mean, spread, length)
Cauchy distribution.
Pgauss(mean, dev, length)
Gaussian (normal) distribution.
Phprand(lo, hi, length)
Returns the greater of two equal-distribution random numbers.
Plprand(lo, hi, length)
Returns the lesser of two equal-distribution random numbers.
Pmeanrand(lo, hi, length)
Returns the average of two equal-distribution random numbers, i.e., (x + y) / 2.
Ppoisson(mean, length)
Poisson distribution.
Pprob(distribution, lo, hi, length, tableSize)
Given an array of relative probabilities across the desired range (a histogram) representing an arbitrary distribution, generates random numbers corresponding to that distribution.
/* examples and this text from https://doc.sccode.org/Browse.html#Streams-Patterns-Events */
</pre>

## Envelopes
  - Synthesizers are constantly running, envelopes wrap around the sound to start and stop it as we please
  - Attack, Decay, Sustain, and Release most common type across electronic music
  - SC can do sustaining (untimed) and un-sustaining envelopes (timed)
    - sustaining: we don't know how it is going to end when it starts
    - un-sustaining: we have to know how it is going to end when it starts
    - Gates control sustaining envelopes (they can open and close)
    - Triggers instigate un-sustaining envelopes
  - **EnvGen** is the UGen to make envelopes (Envelope Generator!)
    - Shapes:
<pre>
Env.linen(1, 2, 3, 0.6).test.plot;
Env.triangle(1, 1).test.plot;
Env.sine(1, 1).test.plot;
Env.perc(0.05, 1, 1, -4).test.plot;
Env.asr(0.2, 0.5, 1, 1).test.plot;
Env.adsr(0.2, 0.2, 0.5, 1, 1, 1).test.plot;
Env.cutoff(1, 1).test(2).plot;
Env.new([0, 1, 0.3, 0.8, 0], [2, 3, 1, 4],'sine').test.plot; //DIY shape
</pre>
  - Done Actions:
<pre>
0 - Do nothing when the envelope has ended.
1 - Pause the synth running, it is still resident.
2 - Remove the synth and deallocate it.
3 - Remove and deallocate both this synth and the preceding node.
4 - Remove and deallocate both this synth and the following node.
5 - Same as 3. If the preceding node is a group then free all members of the group.
6 - Same as 4. If the following node is a group then free all members of the group.
7 - Same as 3. If the synth is part of a group, free all preceding nodes in the group.
8 - Same as 4. If the synth is part of a group, free all following nodes in the group.
9 - Same as 2, but pause the preceding node.
10 - Same as 2, but pause the following node.
11 - Same as 2, but if the preceding node is a group then free its synths.
12 - Same as 2, but if the following node is a group then free its synths.
13 - Frees the synth and all preceding and following nodes.
</pre>
- Example:
<pre>
(
SynthDef("envSynth", {var env;
	env = EnvGen.kr(Env.triangle(1, 1), doneAction:2);
Out.ar(0, Pan2.ar(SinOsc.ar(220), SinOsc.kr(2)))}).add;
)
d= Synth("envSynth");
</pre>

## For next week:
  - Presentation topic emailed to me (rrome at berkleee) and approved
  - Play through all this week's class examples on your own
  - Pick your favorite Simple Pattern or Randomness type
  - Using that favorite type as a template, come to class next week with a PBind program where degree and duration are modified
  - Download and install:
   - [BlackHole](https://github.com/ExistentialAudio/BlackHole)
   - [OBS](https://obsproject.com/)
