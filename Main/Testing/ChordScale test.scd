(
~chordScale = Dictionary.with(*[0->[0,4,7],1->[1,5,8],2->[2,5,9],3->[3,7,10],4->[4,7,11],5->[5,9,12],6->[6,9,12],7->[7,11,14],8->[8,12,15],9->[9,12,16],10->[10,14,17],11->[11,14,17]]);

~scale = Dictionary.with(*[
	0->(1),1->(16/15),2->(9/8),3->(6/5),4->(5/4),5->(4/3),6->sqrt(2),7->(3/2),8->(8/5),9->(5/3),10->(9/5),11->(15/8),12->(2),13->(32/15),14->(9/4),15->(12/5),16->(5/2),17->(8/3)]);

~noteArr = [
	~chordScale.at(0),~chordScale.at(1),~chordScale.at(2),~chordScale.at(3),~chordScale.at(4),~chordScale.at(5),~chordScale.at(6), ~chordScale.at(7),~chordScale.at(8),~chordScale.at(9),~chordScale.at(10),~chordScale.at(11)];
)

~noteArr[0][0];

(
~root = 261;
~tempConst = 0.5;
~voice1.stop;
~voice1= Pbind(
	\instrument, \PianoC3,
	\pan, 0.5,
	\aAtk, 0.001,
	\aDec, 1,
	\dur, ~tempConst,
	\fmAmt, 0.5,
	\oFreq, Pseq([
		//Pseq([~scale.at(~noteArr[0][0]),  ~scale.at(~noteArr[0][1]),  ~scale.at(~noteArr[0][2])],1),//1
		//Pseq([~scale.at(~noteArr[1][0]),  ~scale.at(~noteArr[1][1]),  ~scale.at(~noteArr[1][2])],1),//b2
		//Pseq([~scale.at(~noteArr[2][0]),  ~scale.at(~noteArr[2][1]),  ~scale.at(~noteArr[2][2])],1),//2
		//Pseq([~scale.at(~noteArr[3][0]),  ~scale.at(~noteArr[3][1]),  ~scale.at(~noteArr[3][2])],1),//b3
		//Pseq([~scale.at(~noteArr[4][0]),  ~scale.at(~noteArr[4][1]),  ~scale.at(~noteArr[4][2])],1),//3
		//Pseq([~scale.at(~noteArr[5][0]),  ~scale.at(~noteArr[5][1]),  ~scale.at(~noteArr[5][2])],1),//4
		//Pseq([~scale.at(~noteArr[6][0]),  ~scale.at(~noteArr[6][1]),  ~scale.at(~noteArr[6][2])],1),//b5
		//Pseq([~scale.at(~noteArr[7][0]),  ~scale.at(~noteArr[7][1]),  ~scale.at(~noteArr[7][2])],1),//5
		//Pseq([~scale.at(~noteArr[8][0]),  ~scale.at(~noteArr[8][1]),  ~scale.at(~noteArr[8][2])],1),//b6
		Pseq([~scale.at(~noteArr[9][0]),  ~scale.at(~noteArr[9][1]),  ~scale.at(~noteArr[9][2])],1),//6
		Pseq([~scale.at(~noteArr[10][0]), ~scale.at(~noteArr[10][1]), ~scale.at(~noteArr[10][2])],1),//b7
		Pseq([~scale.at(~noteArr[11][0]), ~scale.at(~noteArr[11][1]), ~scale.at(~noteArr[11][2])],1),//7
	] * ~root, inf),
	\aAmt, 0.01,
).play;
)