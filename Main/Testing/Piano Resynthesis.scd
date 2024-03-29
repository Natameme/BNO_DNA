(
		SynthDef(\PianoC3,{
			arg out = 1, oFreq=160, aAmt=0.05, aAtk= 0.001, aDec= 5.98, hAmt=0.9, nAmt= 1, iAtk = 0.007, iDec=0.022, fFreq = 1000, pan= 0.5, mVol = 1.0, hVol = 0.01, gate=1;
			var osc, ampEnv, hit, bow, filt, sig;
			ampEnv = EnvGen.kr(Env.new([0,aAmt,0], [aAtk,aDec]), gate, doneAction: 2);
			hit = SinOsc.ar(XLine.kr(900, 128, iDec), 0, XLine.kr(hAmt, 0, iDec));
			bow = WhiteNoise.ar(XLine.kr(nAmt*2, 0, iDec));
			osc = Klank.ar(`[[//FREQUENCIES
				oFreq *	1	,
				oFreq *	2.0023023791251	,
				oFreq *	3.00613967766692	,
				oFreq *	4.00767459708365	,
				oFreq *	5.01151189562548	,
				oFreq *	6.01611665387567	,
				oFreq *	7.02302379125096	,
				oFreq *	8.02762854950115	,
				oFreq *	9.04067536454336	,
				oFreq *	10.0537221795856	,
				oFreq *	11.0667689946278	,
				oFreq *	12.07981580967	,
				oFreq *	13.1005372217959	,
				oFreq *	14.1289332310054	,
				oFreq *	15.1419800460476	,
				oFreq *	16.1857252494244	,
				oFreq *	17.2141212586339	,
				oFreq *	18.2578664620107	,
				oFreq *	19.2939370683039	,
				oFreq *	20.3376822716807	,
				oFreq *	21.3891020721412	,
				oFreq *	22.4405218726017	,
				oFreq *	23.4919416730622	,
				oFreq *	24.5587106676899	,
				oFreq *	25.6254796623177	,
				oFreq *	26.7075978511128	,
				oFreq *	27.7820414428243	,
				oFreq *	28.8564850345357	,
				oFreq *	30.2916346891788	],
			[//AMPLITUDES
				1	,
				1.09647819614318	,
				0.630957344480193	,
				0.489778819368446	,
				0.186208713666286	,
				0.242661009508241	,
				0.175994866380147	,
				0.136458313658892	,
				0.0331131121482591	,
				0.0602559586074355	,
				0.204173794466953	,
				0.0234422881531992	,
				0.079432823472428	,
				0.116144861384034	,
				0.00767361489361819	,
				0.0524807460249772	,
				0.0153108746168203	,
				0.025409727055493	,
				0.00803526122185615	,
				0.0167880401812256	,
				0.0350751873952567	,
				0.0173780082874937	,
				0.00638263486190547	,
				0.00676082975391981	,
				0.00954992586021436	,
				0.00582103217770868	,
				0.00645654229034657	,
				0.00741310241300914	,
				0.00245470891568502	],
			[//LENGTHS
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	,
				10	]], hit);
			filt = FreeVerb.ar(osc, 0.5, 1, 0.1, 1);
			sig = Out.ar(out, Pan2.ar((mVol * ((filt * ampEnv)) + (hit * hVol)), pan));
		}).add;
)

(
Synth(\PianoC3, [\aAmt, 0.05]);
)
