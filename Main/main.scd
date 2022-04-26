////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//4. Boot Server
s.boot;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//5. SynthDef Load, Special Thanks to u/Seryth from r/SuperCollider
(
~path = PathName(thisProcess.nowExecutingPath).parentPath;
~synthLib = (~path++"Synths/SynthLibrary.scd");
~mainLib = (~path++"main.scd");
~synthLib.load;
~lib_func.value;
//ServerTree.add(~lib_func);
)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//5a. Test Synths
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Synth(\PianoC3);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//7. Sentiment Scraping
~scraper.value;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//8. SentimentLFO
~sentLFO.value;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//9. Load Pbinds
~notePlay.value;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//6. Load Functions
(
~scraper = {
//create ~sentArr and fill it with 1s by default
~sentArr = Array.newClear(4);
~sentArr = Array.fill(4, 1);
~i = 0;//~ for loop indexing
o = OSCFunc({ arg msg, time, addr, recvPort;
		//add the 4 sentiment values to an array [Positivity, Negativity, Neutrality, Overall]
	~sentArr.put(0, msg[1]);
	~sentArr.put(1, msg[2]);
	~sentArr.put(2, msg[3]);
	~sentArr.put(3, msg[4]);
	"Sentiment".postln;
	~sentArr.postln;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Sentiment Tonnetz Transform
		//performs a tonnetz transformation on the array depending on the overall sentiment
		~x = 0;
		     //p transform
		if(~sentArr[3] > 0.5, {
		Tonnetz(~noteArr[0], ~noteArr[1]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[2]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[3]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[4]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[5]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[6]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[7]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[8]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[9]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[10]).transform(\p);
		Tonnetz(~noteArr[0], ~noteArr[11]).transform(\p);
			//"Tonnetz".postln;//for debugging
			//~noteArr.postln;//for debugging
			~notePlay.value;//re-trigger function
		}, {//r transform
			if(~sentArr[3] > 0.0, {
		Tonnetz(~noteArr[0], ~noteArr[1]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[2]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[3]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[4]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[5]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[6]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[7]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[8]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[9]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[10]).transform(\r);
		Tonnetz(~noteArr[0], ~noteArr[11]).transform(\r);
			//"Tonnetz".postln;//for debugging
			//~noteArr.postln;//for debugging
			~notePlay.value;//re-trigger function
			}, {//l transform
		if(~sentArr[3] > -1, {
		Tonnetz(~noteArr[0], ~noteArr[1]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[2]).transform(\);
		Tonnetz(~noteArr[0], ~noteArr[3]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[4]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[5]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[6]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[7]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[8]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[9]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[10]).transform(\l);
		Tonnetz(~noteArr[0], ~noteArr[11]).transform(\l);
			//"Tonnetz".postln;//for debugging
					~noteArr.postln;//for debugging
			~notePlay.value;//re-trigger function
		})})});
	//resend values to ~sentiment LFO
	if(~i==0, {
			~sentLFO.value;
		});
	~i = ~i+1;
},
'/BNOOSC/Sentiment/');
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//)
//(
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Note Scraping
//noteArr uses scale degrees
~noteArr  = Array.newClear(12);
~noteArr  = Array.fill(12, [0, 4, 7]);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//DICTIONARY DEFS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//n2deg converts a note symbol to a scale degree integer
~n2deg = Dictionary.with(*[
		'A'->9,
		'As'->10,
		'Bf'->10,
		'B'->11,
		'Bs'->0,
		'Cf'->11,
		'C'->0,
		'Cs'->1,
		'Df'->1,
		'D'->2,
		'Ds'->3,
		'Ef'->3,
		'E'->4,
		'Ff'->4,
		'Es'->5,
		'F'->5,
		'Fs'->6,
		'G'->7,
		'Gs'->8,
		'Af'->8
	]);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ChordScale Dictionary Interpolates a scale degree integer into a triad array
~chordScale = Dictionary.with(*[
		0->[0,4,7],
		1->[1,5,8],
		2->[2,5,9],
		3->[3,7,10],
		4->[4,7,11],
		5->[5,9,12],
		6->[6,9,12],
		7->[7,11,14],
		8->[8,12,15],
		9->[9,12,16],
		10->[10,14,17],
		11->[11,14,17]
	]);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//scale sets the pitch ratio per degree (currently set to 12tet)
~scale = Dictionary.with(*[
		0-> 1.0,
		1-> 1.0594630943591,
		2->1.1224620483089,
		3->1.1892071150019,
		4->1.2599210498937,
		5->1.3348398541685,
		6->1.4142135623711,
		7->1.4983070768743,
		8->1.5874010519653,
		9->1.6817928305039,
		10->1.7817974362766,
		11->1.8877486253586,
		12->2.0,
		13->2.1189261887182,
		14->2.2449240966178,
		15->2.3784142300038,
		16->2.5198420997874,
		17->2.669679708337,
		18->2.8284271247422,
		19->2.9966141537486,
		20->3.1748021039306,
		21->3.3635856610078,
		22->3.5635948725532,
		23->3.7754972507172
	]);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//End of Dictionary Defs////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	~n=0;//n for conditional function
	//Note Scraper Function
o = OSCFunc({ arg msg, time, addr, recvPort;
	//[msg, time, addr, recvPort].postln;//for Debugging
	~noteIn = msg[1];
	msg[1].postln;// for Debugging
	~noteVal = ~chordScale.at(~n2deg.at(~noteIn));
	//"Note Value:".postln;//for debugging
	//~noteVal.postln;//for debugging
		//wraps value if ~noteVal is less than 0
		~v = 0; //loop index
		3.do({
			//~v.postln;//for debugging
			//~noteVal[~v] + 12.postln;//for debugging
			if(~noteVal[~v] < 0, {~noteVal[~v] = ~noteVal[~v] + 12});
			~v = ~v+1;
		});
		~noteArr[0] = ~noteVal;
		//////////////////////
	~noteArr.postln;//for debugging
	//for each value up to 11, place noteArr
	if(~n == 11, {
	~notePlay.value;
	~n = 0;
	}, {
		~noteArr[~n+1] = ~noteArr[~n];
		~n = ~n+1;
	});
//End of NoteSraper Function
},
'/BNOOSC/HashNote/');
};//end of Scraper Function
//)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TODO: Telegram Function
/*(
o = OSCFunc({ arg msg, time, addr, recvPort;
		//[msg, time, addr, recvPort].postln;
	//Structure of this message: 4 floats with sentiment analysis and one string with message itself
},
'/BNOOSC/TelegramMsg//');
)*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//7. SentimentLFO
//~sentLFO.value;//for debugging
//(
~sentLFO = {
~lfoConst = 0.1;
	~sentLineOne= Bus.control(s,1);
    ~sentLineTwo= Bus.control(s,1);
    ~sentLineTre= Bus.control(s,1);
    ~sentLineFor= Bus.control(s,1);
{Out.kr(~sentLineOne, SinOsc.kr(~sentArr[0].abs * ~lfoConst, 0, ~sentArr[0].abs))}.play;
{Out.kr(~sentLineTwo, SinOsc.kr(~sentArr[1].abs * ~lfoConst, 0, ~sentArr[1].abs))}.play;
{Out.kr(~sentLineTre, SinOsc.kr(~sentArr[2].abs * ~lfoConst, 0, ~sentArr[3].abs))}.play;
{Out.kr(~sentLineFor, SinOsc.kr(~sentArr[3].abs * ~lfoConst, 0, 10))}.play;
};
//)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//8. Load Pbind
//~notePlay.value;//for debugging
//~posiClock = TempoClock(~sentArr[0]*~tempConst);//for debugging
//~posiClock.tempo;//for debugging
//~neutClock.tempo*2;//for debugging
//(
~notePlay = {
~root = 261;
~tempConst = 60 * (~sentArr[3]+1);
//Tempo Clocks
~posiClock = TempoClock(~sentArr[0].abs*~tempConst);
~negaClock = TempoClock(~sentArr[1].abs*~tempConst);
~neutClock = TempoClock(~sentArr[2].abs*~tempConst);
//synth prob weight arrays
~v1arr= [~sentArr[0], ~sentArr[1], ~sentArr[2]].normalizeSum;
~v2arr= [~sentArr[0], ~sentArr[3]].normalizeSum;
~v3arr= [~sentArr[1], ~sentArr[2], ~sentArr[3]].normalizeSum;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
~voice1.stop;
Pdef(\v1, ~voice1 = Pbind(
		\instrument, Pwrand([\Guitar, \PianoC3, \singingBowl], ~v1arr, inf),
	\pan, Pfunc{~sentLineOne.asMap},
		\fFreq, Pwhite(800, 1000, inf),
	\aAtk, 0.01,
	\aDec, 5,
	\dur, ~posiClock.tempo,
	\oFreq, Prand([
		Pseq([ ~scale.at(~noteArr[0][0]),~scale.at(~noteArr[0][1]),~scale.at(~noteArr[0][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[3][0]), ~scale.at(~noteArr[3][1]),~scale.at(~noteArr[3][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[6][0]), ~scale.at(~noteArr[6][1]),~scale.at(~noteArr[6][2])] * ~root,1),
		Pseq([~scale.at(~noteArr[9][0]), ~scale.at(~noteArr[9][1]),~scale.at(~noteArr[9][2])] * ~root,1)
	], inf),
	\mVol, 0.033,
)).play;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
~voice2.stop;
Pdef(\v2, ~voice2 = Pbind(
	\instrument, Pwrand([\Guitar, \PianoC3], ~v2arr, inf),
	\pan, Pfunc{~sentLineTwo.asMap},
	\fFreq, Pwhite(400, 600, inf),
	\aAtk, 0.001,
	\aDec, 5,
	\dur, ~negaClock.tempo,
	\oFreq, Prand([
		Pseq([~scale.at(~noteArr[1][0]),~scale.at(~noteArr[1][1]),~scale.at(~noteArr[1][2])]    * (~root/4),1),
		Pseq([~scale.at(~noteArr[4][0]),~scale.at(~noteArr[4][1]),~scale.at(~noteArr[4][2])]    * (~root/4),1),
		Pseq([~scale.at(~noteArr[7][0]),~scale.at(~noteArr[7][1]),~scale.at(~noteArr[7][2])]    * (~root/4),1),
		Pseq([~scale.at(~noteArr[10][0]),~scale.at(~noteArr[10][1]),~scale.at(~noteArr[10][2])] * (~root/4),1)
		], inf),
	\mVol, 0.4,
	)).play;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
~voice3.stop;
 Pdef(\v3, ~voice3 = Pbind(
	\instrument, Pwrand([\flue, \fmSynth, \harmonica], ~v3arr, inf),
	\pan, Pfunc{~sentLineTre.asMap},
	\aAtk, 3,
	\dur, ~neutClock.tempo*2,
	\fmAmt, Pfunc{~sentLineFor.asMap},
	\oFreq, Prand([
		Prand([~scale.at(~noteArr[2][0]),~scale.at(~noteArr[2][1]),~scale.at(~noteArr[2][2])]    * (~root/2)  ,1),
		Prand([~scale.at(~noteArr[5][0]),~scale.at(~noteArr[5][1]),~scale.at(~noteArr[5][2])]    * (~root/2)  ,1),
		Prand([~scale.at(~noteArr[8][0]),~scale.at(~noteArr[8][1]),~scale.at(~noteArr[8][2])]    * (~root/2)  ,1),
		Prand([~scale.at(~noteArr[11][0]),~scale.at(~noteArr[11][1]),~scale.at(~noteArr[11][2])] * (~root/2)  ,1)
		], inf),
	\mVol, 0.025;
)).play;
}
)

/*
note allocation
0 1 2 3 4 5 6 7 8 9 10 11
0     3     6     9
  1     4     7     10
    2     5     8      11
*/
//End of Note Hash