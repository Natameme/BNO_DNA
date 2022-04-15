/////////////////////////////////////
//4. Boot Server
s.boot;
/////////////////////////////////////
//5. SynthDef Load, Special Thanks to u/Seryth from r/SuperCollider
(
~path = PathName(thisProcess.nowExecutingPath).parentPath;
~synthLib = (~path++"Synths/SynthLibrary.scd");
~synthLib.load;
ServerTree.add(~lib_func);
)
/////////////////////////////////////
//test synth
Synth(\fmSynth);
/////////////////////////////////////
(//6. Sentiment Scraping
~sentArr = Array.newClear(4);
~sentArr = Array.fill(4, 1);
o = OSCFunc({ arg msg, time, addr, recvPort;
	~sentArr.put(0, msg[1]);
	~sentArr.put(1, msg[2]);
	~sentArr.put(2, msg[3]);
	~sentArr.put(3, msg[4]);
	"Sentiment".postln;
	~sentArr.postln;
},
'/BNOOSC/Sentiment/');
//)
//(
//Note Scraping
//noteArr uses scale degrees
~noteArr  = Array.newClear(12);
~noteArr  = Array.fill(12, [0, 4, 7]);
//dictionary definitions
~chordScale = Dictionary.with(*[0->[0,4,7],1->[1,5,8],2->[2,5,9],3->[3,6,10],4->[4,6,11],5->[5,8,12],6->[6,8,12],7->[7,9,14],8->[8,12,15],9->[9,12,16],10->[10,14,17],11->[11,14,17]]);

~scale = Dictionary.with(*[
	0->(1),1->(16/15),2->(9/4),3->(6/5),4->(5/4),5->(4/3),6->sqrt(2),7->(3/2),8->(8/5),9->(5/3),10->(9/5),11->(15/8),12->(2),13->(32/15),14->(9/4),15->(12/5),16->(5/2),17->(8/3)]);
//n for conditional function
~n=0;
o = OSCFunc({ arg msg, time, addr, recvPort;
		//[msg, time, addr, recvPort].postln;
	~noteIn = msg[1];
	~noteVal = ~chordScale.at((~noteIn.ascii.at(0)-65));
	~noteArr[0] = ~noteVal;
	//for each value up to 11, place noteArr
	if(~n == 11, {
	~n = 0;
	}, {
		~noteArr[~n+1] = ~noteArr[~n];
		~n = ~n+1;
		"Note".postln;
		~noteArr.postln;
	});
	//
},
'/BNOOSC/HashNote/');
)
/////////////////////////////////////
(
//7. SentimentLFO
	~sentRate=[1, 1, 1];
	~sentLine= Bus.control(s,1);
    ~sentGen = {Out.kr(~sentLine, SinOsc.kr(1, 0, 5))};
)
/////////////////////////////////////
//TODO: make this block of code trigger remotely when NoteScraper Fires
(//8. Load Pbind
~root = 261;
~tempConst = 30;
~voice1.stop;
~voice1= Pbind(
	\instrument, \PianoC3,
	\pan, 0.5,
	\aAtk, 0.001,
	\dur, ~sentArr[1]*~tempConst,
	\fmAmt, Pfunc{~sentLine.asMap},
	\oFreq, Prand([
		Pseq([~scale.at(~noteArr[0][0]),~scale.at(~noteArr[0][1]),~scale.at(~noteArr[0][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[3][0]),~scale.at(~noteArr[3][1]),~scale.at(~noteArr[3][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[6][0]),~scale.at(~noteArr[6][1]),~scale.at(~noteArr[6][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[9][0]),~scale.at(~noteArr[9][1]),~scale.at(~noteArr[9][2])] * ~root,1),
	], inf),
	\aAmt, 0.01,
).play;
////////////
~voice2.stop;
~voice2= Pbind(
	\instrument, \fmSynth,
	\pan, 0.5,
	\aAtk, 0.01,
	\dur, ~sentArr[2]*~tempConst,
	\fmAmt, Pfunc{~sentLine.asMap},
	\oFreq, Prand([
		Pseq([~scale.at(~noteArr[1][0]),~scale.at(~noteArr[1][1]),~scale.at(~noteArr[1][2])]    * (~root/2),1),
		Pseq([~scale.at(~noteArr[4][0]),~scale.at(~noteArr[4][1]),~scale.at(~noteArr[4][2])]    * (~root/2),1),
		Pseq([~scale.at(~noteArr[7][0]),~scale.at(~noteArr[7][1]),~scale.at(~noteArr[7][2])]    * (~root/2),1),
		Pseq([~scale.at(~noteArr[10][0]),~scale.at(~noteArr[10][1]),~scale.at(~noteArr[10][2])] * (~root/2),1),
	], inf),
	\aAmt, 0.03,
).play;
////////////
~voice3.stop;
~voice3= Pbind(
	\instrument, \harmonica,
	\pan, 0.5,
	\aAtk, 1,
	\dur, ~sentArr[3]*~tempConst,
	\fmAmt, Pfunc{~sentLine.asMap},
	\oFreq, Prand([
		Prand([~scale.at(~noteArr[2][0]),~scale.at(~noteArr[2][1]),~scale.at(~noteArr[2][2])]    * (~root)  ,1),
		Prand([~scale.at(~noteArr[5][0]),~scale.at(~noteArr[5][1]),~scale.at(~noteArr[5][2])]    * (~root)  ,1),
		Prand([~scale.at(~noteArr[8][0]),~scale.at(~noteArr[8][1]),~scale.at(~noteArr[8][2])]    * (~root)  ,1),
		Prand([~scale.at(~noteArr[11][0]),~scale.at(~noteArr[11][1]),~scale.at(~noteArr[11][2])] * (~root)  ,1),
	], inf),
	\mVol, 0.03,
).play;
)

/*
note allocation
0 1 2 3 4 5 6 7 8 9 10 11
0     3     6     9
  1     4     7     10
    2     5     8      11
*/