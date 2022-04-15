
(
~sentArr = [0,0];

~sentiment = OSCFunc({ arg msg, time, addr, recvPort;
	//spit out OSC float
	~timbre = msg[1]*10;
	//load variable into array stream
	~sentArr.put(1, ~sentArr[0]);
	~sentArr.put(0, ~timbre);
	~sentArr.postln;
	//convert array into line
	~ctrlLine= Bus.control(s,1);
	{Out.kr(~crtlLine, Line.kr(~sentArr[1], ~sentArr[0], dur: 1, mul: 1))};
},

'/BNOOSC/Sentiment/');
)



//test code
~testArr = [0,0];
(
~newVal = 1.0.linrand;


~testArr.put(1, ~testArr[0]);
~testArr.put(0, ~newVal);

)




//NOTEHASH
// Take input into array
(
//Note Array
~note = Array.new(16);
~noteHash = OSCFunc({ arg msg, time, addr, recvPort;
	~val = msg[1];
	~note.addFirst((~val.ascii.at(0)-64*1.0)*0.571428571428571);
	~note;
	~note.postln;
},
'/BNOOSC/HashNote/');
)


(
~root = 261;
~bells.stop;
~bells= Pbind(
	\instrument, \PianoC3,
	\pan, 0.9,
	\dur, Pwhite(~sentArr[0],~sentArr[1],inf),
	\fmAmt, 1,
	\oFreq, Prand([
		~root * ~note[0],
		~root * ~note[1],
		~root * ~note[2],
		~root * ~note[3],
		~root * ~note[4],
		~root * ~note[5],
		~root * ~note[6],
		~root * ~note[7],
		~root * ~note[8],
		~root * ~note[9],
		~root * ~note[10],
		~root * ~note[11],
		~root * ~note[12],
		~root * ~note[13],
		~root * ~note[14],
		~root * ~note[15]
	], inf),
	\aAmt, 0.08,
).play;
)


~note.windex;

[1.0, 1.0, 3.0, 3.0, 3.0, 3.0, 3.0].windex.postln;
~val.ascii-65;

'A'.ascii;
'B'.ascii;
'C'.ascii;
'D'.ascii;
'E'.ascii;
'F'.ascii;
'G'.ascii-64;

"foo".postln;


(
~value = 'c';
~noteArr = Array.new(16);
16.do({arg i = 0; ~noteArr[i+1] = ~noteArr[i]});
~noteArr[0]=~value;
)

