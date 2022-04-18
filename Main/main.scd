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
Synth(\Guitar);
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
~chordScale = Dictionary.with(*[0->[0,4,7],1->[1,5,8],2->[2,5,9],3->[3,7,10],4->[4,7,11],5->[5,9,12],6->[6,9,12],7->[7,11,14],8->[8,12,15],9->[9,12,16],10->[10,14,17],11->[11,14,17]]);
//~scale = Dictionary.with(*[	0->(1),1->(16/15),2->(9/4),3->(6/5),4->(5/4),5->(4/3),6->sqrt(2),7->(3/2),8->(8/5),9->(5/3),10->(9/5),11->(15/8),12->(2),13->(32/15),14->(9/4),15->(12/5),16->(5/2),17->(8/3)]);
~scale = Dictionary.with(*[0-> 1.0, 1-> 1.0594630943591, 2->1.1224620483089, 3->1.1892071150019, 4->1.2599210498937, 5->1.3348398541685, 6->1.4142135623711, 7->1.4983070768743, 8->1.5874010519653, 9->1.6817928305039, 10->1.7817974362766, 11->1.8877486253586, 12->2.0, 13->2.1189261887182, 14->2.2449240966178, 15->2.3784142300038, 16->2.5198420997874, 17->2.669679708337, 18->2.8284271247422, 19->2.9966141537486, 20->3.1748021039306, 21->3.3635856610078, 22->3.5635948725532, 23->3.7754972507172]);
//note symbol to degree conversion
~n2deg = Dictionary.with(*['A'->9,'As'->10,'B'->11,'C'->0,'Cs'->1,'D'->2,'Ds'->3,'E'->4,'F'->5,'Fs'->6,'G'->7]);
//n for conditional function
~n=0;
o = OSCFunc({ arg msg, time, addr, recvPort;
		//[msg, time, addr, recvPort].postln;
	~noteIn = msg[1];
	~noteVal = ~chordScale.at(~n2deg.at(~noteIn));
	~noteArr[0] = ~noteVal;
	~noteArr.postln;
	//for each value up to 11, place noteArr
	if(~n == 11, {
	~notePlay.value;
	~n = 0;
	}, {
		~noteArr[~n+1] = ~noteArr[~n];
		~n = ~n+1;
	});

},
'/BNOOSC/HashNote/');

)
~notePlay.value;
/////////////////////////////////////
(
//7. SentimentLFO
~lfoConst = 0.1;
	~sentLineOne= Bus.control(s,1);
    ~sentLineTwo= Bus.control(s,1);
    ~sentLineTre= Bus.control(s,1);
    ~sentLineFor= Bus.control(s,1);
{Out.kr(~sentLineOne, SinOsc.kr(~sentArr[0].abs * ~lfoConst, 0, ~sentArr[0].abs))}.play;
{Out.kr(~sentLineTwo, SinOsc.kr(~sentArr[1].abs * ~lfoConst, 0, ~sentArr[1].abs))}.play;
{Out.kr(~sentLineTre, SinOsc.kr(~sentArr[2].abs * ~lfoConst, 0, ~sentArr[3].abs))}.play;
{Out.kr(~sentLineFor, SinOsc.kr(~sentArr[3].abs * ~lfoConst, 0, ~sentArr[3].abs))}.play;
)

~sentArr
/////////////////////////////////////
(//8. Load Pbind
~notePlay = {
~root = 200;
~tempConst = 30;
~voice1.stop;
Pdef(\v1, ~voice1=Pbind(
	\instrument, \PianoC3,
	\pan, 0.5,
	\aAtk, 0.01,
	\dur, ~sentArr[1]*~tempConst,
	\fmAmt, Pfunc{~sentLineOne.asMap},
	\fFreq, 500,
	\oFreq, Prand([
		Pseq([  ~scale.at(~noteArr[0][0]),
				~scale.at(~noteArr[0][1]),
				~scale.at(~noteArr[0][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[3][0]),
		~scale.at(~noteArr[3][1]),~scale.at(~noteArr[3][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[6][0]),~scale.at(~noteArr[6][1]),~scale.at(~noteArr[6][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[9][0]),~scale.at(~noteArr[9][1]),~scale.at(~noteArr[9][2])] * ~root,1),
	], inf),
	\aAmt, 0.01,
)).play;
////////////////////////////////////////////////////////////
~voice2.stop;
Pdef(\v2, ~voice2= Pbind(
	\instrument, \Guitar,
	\pan, 0.5,
	\aAtk, 0.01,
	\dur, ~sentArr[2]*~tempConst,
	\fmAmt, Pfunc{~sentLineTwo.asMap},
	\oFreq, Prand([
		Pseq([~scale.at(~noteArr[1][0]),~scale.at(~noteArr[1][1]),~scale.at(~noteArr[1][2])]    * (~root/2),1),
		Pseq([~scale.at(~noteArr[4][0]),~scale.at(~noteArr[4][1]),~scale.at(~noteArr[4][2])]    * (~root/2),1),
		Pseq([~scale.at(~noteArr[7][0]),~scale.at(~noteArr[7][1]),~scale.at(~noteArr[7][2])]    * (~root/2),1),
		Pseq([~scale.at(~noteArr[10][0]),~scale.at(~noteArr[10][1]),~scale.at(~noteArr[10][2])] * (~root/2),1),
	], inf),
	\aAmt, 0.03,
)).play;
////////////
~voice3.stop;
 Pdef(\v3, ~voice3= Pbind(
	\instrument, \fmSynth,
	\pan, 0.5,
	\aAtk, 3,
	\dur, ~sentArr[3]*~tempConst.abs,
	\fmAmt, Pfunc{~sentLineTre.asMap},
	\oFreq, Prand([
		Prand([~scale.at(~noteArr[2][0]),~scale.at(~noteArr[2][1]),~scale.at(~noteArr[2][2])]    * (~root)  ,1),
		Prand([~scale.at(~noteArr[5][0]),~scale.at(~noteArr[5][1]),~scale.at(~noteArr[5][2])]    * (~root)  ,1),
		Prand([~scale.at(~noteArr[8][0]),~scale.at(~noteArr[8][1]),~scale.at(~noteArr[8][2])]    * (~root)  ,1),
		Prand([~scale.at(~noteArr[11][0]),~scale.at(~noteArr[11][1]),~scale.at(~noteArr[11][2])] * (~root)  ,1),
	], inf),
	\mVol, 0.03,
)).play;

})



/*
note allocation
0 1 2 3 4 5 6 7 8 9 10 11
0     3     6     9
  1     4     7     10
    2     5     8      11
*/
