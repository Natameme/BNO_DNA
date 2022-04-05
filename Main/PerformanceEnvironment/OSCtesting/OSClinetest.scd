
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
~noteHash = OSCFunc({ arg msg, time, addr, recvPort;
	~val = msg[1];
	~note = Array.new(16);
	~note.do({ arg n; ~val});
	~note.postln;
},
'/BNOOSC/HashNote/');
)

"foo".postln;


(
~value = 'c';
~noteArr = Array.new(16);
16.do({arg i = 0; ~noteArr[i+1] = ~noteArr[i]});
~noteArr[0]=~value;
)