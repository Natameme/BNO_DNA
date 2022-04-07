/*
MAIN PERFORMANCE ENVIRONMENT

how to start

1.  Run main.py in TwitterScraping folder from terminal

2. Trigger OSC Parsing Code in SC

3. Trigger Pbind Code

*/
//SELF DESTRUCT BUTTON: turns off twitter scraper and kills server
/*(
Pipe.new("cd " ++ ~path ++ "/main.py", "w");
)*/

s.boot;
//~oscModule = ("cd " ++ ~path ++ "TwitterScraping/main.py");
(
~path = PathName(thisProcess.nowExecutingPath).parentPath; //++"subFolder/"
~synthLib = (~path++"Synths/SynthLibrary.scd");
~synthLib.load;
ServerTree.add(~lib_func);
)


//2. OSC Parsing from Twitter Scraper
/*(
Pipe.new("cd " ++ ~path ++ "TwitterScraping/main.py && python3 main.py" , "w");
Pipe.new("" , "w");
)*/
(
//Sentiment Scraper
~sentArr = Array.new(4);
~sentArr.fill(4, 0);

~note = Array.new(16);
~note.fill(16, 0);


~sentOn = 0;

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
//Scale Dictionary
~scale = Dictionary.with(*[0->(5/3), 1->(15/8), 2->1, 3->(9/8), 4->(5/4), 5->(4/3), 6->(3/2)]);

//~noteArr = Array.new(16);
//~noteArr = Array.fill(16, 1);

~noteHash = OSCFunc({ arg msg, time, addr, recvPort;
	~noteOn = 1;
	~val = msg[1];
	~note.addFirst((~val.ascii.at(0)-64));
	//Note Array
	i = 0;
	16.do({
		// i.postln;
		~noteArr[i] = ~scale.at(~note[i]);// * ~root;
		i = i+1;
	});
	~noteArr.postln;
},
'/BNOOSC/HashNote/');
)
//Testing
//~note.postln;
//~noteArr.postln;

//3. Trigger Note Generator, you may need to wait until NoteHash function has fired
//TODO: add noteOn triggering to prevent errors at beginning of composition

(
~sentLine=Bus.control(s, 1);
{Out.kr(~sentLine, Line.kr(~sentArr[0], ~sentArr[1], ~sentArr[2]))}.play;

~root = 100;
~bells.stop;
~bells= Pbind(
	\instrument, \PianoC3,
	\pan, 0.9,
	\dur, Prand([1, 2, 3] ,inf),
	\fmAmt, Pfunc{~sentLine.asMap},
	\oFreq, Prand(~noteArr * ~root, inf),
	\aAmt, 0.08,
).play;
)
~noteArr;