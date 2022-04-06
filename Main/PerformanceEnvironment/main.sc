/*
MAIN PERFORMANCE ENVIRONMENT

how to start

1.  Run main.py in TwitterScraping folder from terminal
1a. Boot SC server
1b. Trigger OSC Parsing Code in SC

2. (NEEDS FIX) wait for 4 values to accumulate in sentiment array, and 16 in the note array
2a.(NEEDS FIX) Open SynthLibrary.scd and Trigger Synthdefs

3. Trigger Pbind Code
*/

File.open("/Users/gnat/Documents/GitHub/BNO_DNA/Main/Synths/SynthLibrary.scd", r);


//1b. OSC Parsing from Twitter Scraper
(
~sentOn = 0;
//Sentiment Scraper
~sentArr = Array.new(4);
//OSC function
~sentiment = OSCFunc({ arg msg, time, addr, recvPort;
	~sentOn = 1;
	//spit out OSC float
	~timbre = msg[1]*10;
	//load variable into array stream
	~sentArr.addFirst(~timbre);
	~sentArr.postln;
	//convert array into line
	~ctrlLine= Bus.control(s,1);
	{Out.kr(~crtlLine, Line.kr(~sentArr[1], ~sentArr[0], dur: 1, mul: 1))};
},

'/BNOOSC/Sentiment/');

//NOTEHASH
// Take input into array
~noteOn = 0;
//Note Array
~note = Array.new(16);
~noteHash = OSCFunc({ arg msg, time, addr, recvPort;
	~noteOn = 1;
	~val = msg[1];
	~note.addFirst((~val.ascii.at(0)-64));
	~note;
	~note.postln;
},
'/BNOOSC/HashNote/');
)

//Note Generator
//TODO: add noteOn triggering to prevent errors at beginning of composition
(
~sentLine=Bus.control(s, 1);
{Out.kr(~sentLine, Line.kr(~sentArr[0], ~sentArr[1], ~sentArr[2]))}.play;

~root = 261;
~bells.stop;
~bells= Pbind(
	\instrument, \PianoC3,
	\pan, 0.9,
	\dur, Prand([~sentArr[0]*10, ~sentArr[1]*10, ~sentArr[2]*10, ~sentArr[3]*10],inf),
	\fmAmt, Pfunc{~sentLine.asMap},
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