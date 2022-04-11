//1. Boot Server
s.boot;

//2. SynthDef Load
(
~path = PathName(thisProcess.nowExecutingPath).parentPath;
~synthLib = (~path++"Synths/SynthLibrary.scd");
~synthLib.load;
ServerTree.add(~lib_func);
Synth(\PianoC3);
)


//3. Load python script in Terminal Window

(//4. Sentiment Scraping
~sentArr = Array.newClear(4);
~sentArr = Array.fill(4, 0);
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
~noteArr = Array.newClear(15);
~noteArr = Array.fill(15, 1);
~scale = Dictionary.with(*[0->(5/3), 1->(15/8), 2->1, 3->(9/8), 4->(5/4), 5->(4/3), 6->(3/2)]);
~n=0;
o = OSCFunc({ arg msg, time, addr, recvPort;
		//[msg, time, addr, recvPort].postln;
	~noteIn = msg[1];
	~noteVal = /*~scale.at*/((~noteIn.ascii.at(0)-65));
	~noteArr[0] = ~noteVal;
    	//16.do{
	if(~n == 14, {
	//~bells.reset;
	~n = 0;
	}, {
		~noteArr[~n+1] = ~noteArr[~n];
		~n = ~n+1;
		"Note".postln;
		~noteArr.postln;
	});
},
'/BNOOSC/HashNote/');

//SentimentLFO
	~sentRate=[1, 1, 1];
	~sentLine= Bus.control(s,1);
	~sentGen = {Out.kr(~sentLine, Env.new(levels: ~sentArr*10, times: ~sentRate, curve: ~sentRate, loopNode: 3, releaseNode: 3))};
)

//PBIND
~noteArr.normalize;
(//6. Load Pbind
~root = 261;
~bells.stop;
~bells= Pbind(
	\instrument, \PianoC3,
	\pan, 0.5,
	\dur, Prand([0.33] ,inf),
	\fmAmt, Pfunc{~sentLine.asMap},
	\oFreq, Prand(~noteArr * ~root, inf),
	\aAmt, 0.08,
).play;
)

(
~bells.stop;
~bells.play;
)
~bells.reset;