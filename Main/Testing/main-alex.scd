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
//5a. Test Synths
Synth(\Guitar);

//6. Sentiment Scraping
~scraper.value;
//7. SentimentLFO
~sentLFO.value;
//8. Load Pbinds
~notePlay.value;

/////////////////////////////////////
//test synth

/////////////////////////////////////
(
~scraper = {//6. Sentiment Scraping
	~sentArr = Array.newClear(4);
	~sentArr = Array.fill(4, 1);
	~i = 0;
	o = OSCFunc({ arg msg, time, addr, recvPort;
		~sentArr.put(0, msg[1]);
		~sentArr.put(1, msg[2]);
		~sentArr.put(2, msg[3]);
		~sentArr.put(3, msg[4]);
		"Sentiment".postln;
		~sentArr.postln;
		if(~i==0, {~sentLFO.value;});
		~i = ~i+1;
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
	//~scale = Dictionary.with(*[	0->(1),1->(16/15),2->(9/4),3->(6/5),4->(5/4),5->(4/3),6->sqrt(2),7->(3/2),8->(8/5),9->(5/3),10->(9/5),11->(15/8),12->(2),13->(32/15),14->(9/4),15->(12/5),16->(5/2),17->(8/3)]);//JI
	~scale = Dictionary.with(*[0-> 1.0, 1-> 1.0594630943591, 2->1.1224620483089, 3->1.1892071150019, 4->1.2599210498937, 5->1.3348398541685, 6->1.4142135623711, 7->1.4983070768743, 8->1.5874010519653, 9->1.6817928305039, 10->1.7817974362766, 11->1.8877486253586, 12->2.0, 13->2.1189261887182, 14->2.2449240966178, 15->2.3784142300038, 16->2.5198420997874, 17->2.669679708337, 18->2.8284271247422, 19->2.9966141537486, 20->3.1748021039306, 21->3.3635856610078, 22->3.5635948725532, 23->3.7754972507172]);
	//note symbol to degree conversion
	~n2deg = Dictionary.with(*['A'->9,'As'->10,'B'->11,'C'->0,'Cs'->1,'D'->2,'Ds'->3,'E'->4,'F'->5,'Fs'->6,'G'->7]);
	//n for conditional function
	~n=0;
	o = OSCFunc({ arg msg, time, addr, recvPort;
		//[msg, time, addr, recvPort].postln;
		~noteIn = msg[1];
		msg[1].postln;
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
})

/////////////////////////////////////



~notearr.postln;

/* ———————————— below is the part i modified ———————————— */

( /* set up global variables and functions */
~currSent = 0.5; // initialize current sentiment (eventually this would prob be part of the global init function)

/* "evolve" functions */
~initEvolve = { // initializes the Tonnetz class and ~dir according to the sentiment value and sets ~numOfChanges to 0. execute this function once at the very beginning of the installation/performance
	| sentiment |
	var chord; // if sentiment increases, dir = 1; if it decreases, dir = 0. init assumes that if Twitter starts a day happy, it will keep getting happier (dir=1), and vice versa
	chord = case
	{ sentiment > 0.8 } { [0, 5, 9] } // F/C
	{ sentiment > 0.6 } { [1, 4, 9] } // A/C# (also ChordFunc.toChord apparently doesn't work with this chord??)
	{ sentiment > 0.5 } { [0, 4, 7] } // C
	{ sentiment > 0.4 } { [0, 3, 7] } // Cm
	{ sentiment > 0.2 } { [-2, 3, 6] } // Ebm/Bb
	{ [-4, 0, 5] }; // Fm/C
	chord = chord + 48; // assuming we want to make the chord start somewhere around middle C
	~tntz = Tonnetz(chord, chord);
	~dir = if (sentiment > 0.5, { 1 }, { 0 });
	~numOfChanges = 0;
	chord;
};
~evolve = { // transforms the current chord according to change in sentiment value
	| change = 0.2 |
	var dir, transform, changeAbs;
	dir = case
	{ change > 0 } { 1 } // if increase, dir = 1
	{ 0 }; // if decrease or no change, dir = 0
	changeAbs = change.abs;
	if (change == 0, // if no change, do nothing
		{ "no change".postln },
		{
			if (dir == ~dir, // if direction did not change
				{
					~numOfChanges = ~numOfChanges + 1;
					transform = if ( ~numOfChanges % 2 == 1, { \rp }, { \pl });
				},
				{
					~dir = dir;
					transform = case
					{ changeAbs > 0.8 } { \p }
					{ changeAbs > 0.4 } { \r }
					{ \l };
				}
			);
			~tntz.transform(transform);
		}
	);
};

//7. SentimentLFO
~sentLFO = {
	~lfoConst = 0.1;
	~sentLineOne= Bus.control(s,1);
	~sentLineTwo= Bus.control(s,1);
	~sentLineTre= Bus.control(s,1);
	~sentLineFor= Bus.control(s,1);
	{Out.kr(~sentLineOne, SinOsc.kr(~sentArr[0].abs * ~lfoConst, 0, ~sentArr[0].abs))}.play;
	{Out.kr(~sentLineTwo, SinOsc.kr(~sentArr[1].abs * ~lfoConst, 0, ~sentArr[1].abs))}.play;
	{Out.kr(~sentLineTre, SinOsc.kr(~sentArr[2].abs * ~lfoConst, 0, ~sentArr[3].abs))}.play;
	{Out.kr(~sentLineFor, SinOsc.kr(~sentArr[3].abs * ~lfoConst, 0, ~sentArr[3].abs))}.play;
};

~sentLFO.value;

//8. Load Pdefs
~notePlay = {
	| chord |
	/*~root = 261;
	~tempConst = 30;
	~voice1.stop;
	Pdef(\v1, ~voice1=Pbind(
	\instrument, \PianoC3,
	\pan, 0.5,
	\aAtk, 0.01,
	\dur, ~sentArr[1]*~tempConst,
	\fFreq, Pfunc{~sentLineOne.asMap*500},
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
	\fFreq, Pfunc{~sentLineTwo.asMap*1000},
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
	)).play;*/
	Pdef(\evo1, Pbind(
		\instrument, \fmSynth2,
		\pan, 0.5,
		\aAtk, 3,
		\dur, 3, // TBD
		\fmAmt, Pfunc{~sentLineTre.asMap}, // i couldn't get ~sentLineTre to work for some reason
		\scale, Scale.chromatic(\just), // i think this is the same JI tuning Natalie uses?
		\degree, chord[0], // instead of midinote, degree is used in conjunction with octave here in order for Scale.chromatic(\just) to work
		\octave, 1, // so that degree works more or less like midinote but with JI
		\mVol, 0.03,
	)).play;
	Pdef(\evo2, Pbind(
		\instrument, \fmSynth2,
		\pan, 0.5,
		\aAtk, 3,
		\dur, 3,
		\fmAmt, Pfunc{~sentLineTre.asMap},
		\scale, Scale.chromatic(\just),
		\degree, chord[1],
		\octave, 1,
		\mVol, 0.03,
	)).play;
	Pdef(\evo3, Pbind(
		\instrument, \fmSynth2,
		\pan, 0.5,
		\aAtk, 3,
		\dur, 3,
		\fmAmt, Pfunc{~sentLineTre.asMap},
		\scale, Scale.chromatic(\just),
		\degree, chord[2],
		\octave, 1,
		\mVol, 0.03,
	)).play;
};

/* fetches new sentiment values, calculates the change in sentiment value, and generates & plays a chord based on that */
~evolveNotePlay = {
	var sentiment, diffSent;
	sentiment = 1.0.rand; // this would be where new sentiment values are fetched, but i haven't figure out how to do that yet..
	diffSent = sentiment - ~currSent;
	~notePlay.value(~evolve.value(diffSent)); // play a chord according to the change in sentiment value
	~currSent = sentiment; // set ~currSent to the new sentiment value
};


// Routine currently generates a new chord every 6 sec
Routine({
	~notePlay.value(~initEvolve.value(~currSent)); // initializes evolve based on current sentiment
	6.0.wait; // TBD
	inf.do({
		~evolveNotePlay.value;
		//Synth(\fmSynth2);
		6.0.wait; // this is the interval at which sentiment values are fetched
	})
}).play;
)




/*
note allocation
0 1 2 3 4 5 6 7 8 9 10 11
0     3     6     9
1     4     7     10
2     5     8      11
*/
