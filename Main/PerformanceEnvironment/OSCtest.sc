

//MODIFIED CODE

/*
GENERAL TODO:
> note trigger from data?
> Modulation sources?
> Composition System (neo-riemannian theory?)
> Add Performance Concepts

for Saturday 4/9: get some proof-of-concept demo running
*/


//SENTIMENT
/*TODO:
interpolate sentiment value into a scale selector system*/
(
~sentiment = OSCFunc({ arg msg, time, addr, recvPort;
	~timbre = msg[1]; },
~timbre.postln;

'/BNOOSC/Sentiment/');

)

/*m2*/ 16/15;
/*M2*/ 9/8;
/*m3*/ 6/5;
/*n3*/ 11/9;
/*M3*/ 5/4;
/*P4*/ 4/3;
/*#4*/ 7/5;
/*P5*/ 3/2;
/*m6*/ 8/5;
/*n6*/ 8/11;
/*M6*/ 5/3;
/*m7*/ 9/5;
/*M7*/ 15/8;
//LFO Realtime Control Test
(
~lfo1 = Bus.control(s,1);
~lfo2 = Bus.control(s,1);

{Out.kr(~lfo1, SinOsc.kr(0.1, mul: 5))}.play;
{Out.kr(~lfo2, SinOsc.kr(0.3, mul: 0.5))}.play;
)

(
~bells.stop;
~bells= Pbind(
	\instrument, \fmSynth,
	\pan, 0.9,
	\dur, 0.7,
	\fmAmt, Pfunc{~lfo1.asMap},
	\oFreq, Pseq([
		~root*(1),
		~root*(3/2),
		~root*(9/4),
		~root*(5/2),
		~root*(3)
	]
	, inf),
	\aAmt, 0.4,
	\pan, Pfunc{~lfo2.asMap}
).play;
)

~timbre * 100;


//CUSTOM HASH

/*
TODO:
interpolate message into a system that allows control of SC data
*/

(
~custHash = OSCFunc({ arg msg, time, addr, recvPort;
		[msg, time, addr, recvPort].postln; },
'/BNOOSC/CustomHashtag/');
)


//HASH NOTE
/*TODO:
add noteHash contents to a stream, which selects different scale degrees for use in note triggering*/
(
~noteHash = OSCFunc({ arg msg, time, addr, recvPort;
	//msg[1].postln;
	~note = Bag.new(n: 16);
	~note.add(msg[1]);
	~note.contents.postln;
},
'/BNOOSC/HashNote/');
)




