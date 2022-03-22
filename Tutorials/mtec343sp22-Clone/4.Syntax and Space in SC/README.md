# Patterns

## Performances!

## Getting Started with SuperCollider
- Object-Oriented, based on smalltalk
- What you downloaded was actually three things:
  - sclang (client), scserver (server), scide
- [Client vs Server](https://doc.sccode.org/Guides/ClientVsServer.html)
- You can run server(s) from anything/anywhere
- Interpreted OOP and liveness? maybe they're made for each other?
  - Never compiled, so even loops need their own object to iterate
- IDE: Text Editor, Post window, Help browser
- Client (Interpreter/Language) boots when you open IDE
- You do need to boot the Server  with **Command|B**
- You see your I/O in the Post window after booting
- [You might need to change them/select them with this code](https://doc.sccode.org/Reference/AudioDeviceSelection.html)
- If you I/O audio rates don't match, the server won't boot and you'll need to make sure they match in your Audio MIDI setup
- Evaluate single line code with **Shift|Return**
-
- ***Beware Zombie servers***
- Code along:
<pre>
"Hello, World".postln;
{SinOsc.ar(440)}.play;
</pre>
- Everything's in mono by default
- "Syntax Sugar": many ways to write out the same thing
- Many ways to do the same thing!
- How to use Help!

## SPACE
- Who is who in the speaker array?

## SC Language
- Syntax
  - ; for each expression
  - ((Gotta) match brackets)
  -
  <pre>
  // This is a single line comment
  /*
  And this is
  also a comment
  */
  </pre>

- Variables
  - Containers of a value
  - You need to declare them but not their type (which is good and bad)
  - Local variables in brackets
  <pre>
  a = 1;
  (
  var a;
  a = 3;
  )
  a
  </pre>
  - Global variables use **~**, but we don't use them much in live coding
- Keys
  - Keywords that identify types of values
- Functions
  - Encapsulate functionality you want to reuse
  - **{}**
  - We've already used one with **{}.play**
- Arrays and Lists
  - What are tuning systems but arrays and lists?
  <pre>
  m = Scale.minor.degrees; // Scale class returns the degrees of the minor scale
  m = m.midicps // turns the MIDI notes into their frequency values
  </pre>
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
      == = equal to
      != = not equal to
      && = and
      || = or
  </pre>

- Iterating and looping
  - Because SC is totally an interpreted OOP language (never ever compiled), we have to use an object method to iterate
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
  - Many classes of them
  - Modular building blocks of synthesis systems
  - Think of them like modules in your synthesizer
  - They make a waveform, a filter, etc.
  - In SC they're actually written in C/C++ and are a plugin to the SC Server, but most come standard with download
  - Most UGen classes have Audio Rate **.ar** and Control Rate **.kr** signal methods internal to the language, sent out as OpenSoundControl data to the server

- **SynthDef**
  - A class which pre-compiles multiple unit generators
  - Great for reuse
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
Ndef(\first).stop
Ndef(\first, {|freq= 400| SinOsc.ar(freq)})
Ndef(\first).play
Ndef(\first).set(\freq, 300)
/* examples from https://fredrikolofsson.com/code/sc/ */
</pre>


## For next week:
  - Play through all class examples on your own
  - Presentation topic emailed to me (rrome at berkleee) and approved
