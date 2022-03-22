/*alloy(2013)
recording at https://archive.org/details/devorahalloy
made this in my ma program at mills, was portfolio piece for my phd applications
*/
//synth
(SynthDef(\fm,{ |freq=43,harm=1,dur=4,start=1,dpth=6,end=1,att=0.5,rls=0.5|
var fm = PMOsc.ar(freq,freq*harm, EnvGen.kr(Env.new([start, dpth,
end],[att*dur,rls*dur])));
Out.ar(0,fm*EnvGen.ar(Env.linen(1,dur-2,1,1),doneAction: 2))
}).store);
//routine
(
r = Routine({
a = Synth(\fm, [harm:1, dur:40,start:1,dpth:16,end:4,att:0.75,rls:0.25]);
39.wait;
a = Synth(\fm, [harm:2, dur:56,start:3,dpth:16,end:4,att:0.5,rls:0.5]);
55.wait;
a = Synth(\fm, [harm:1, dur:64,start:3,dpth:16,end:1,att:0.25,rls:0.75]);
63.wait;
b = Synth(\fm, [harm:2, dur:16,start:3,dpth:6,end:1,att:0.75,rls:0.25]);
15.wait;
c = Synth(\fm, [harm:3, dur:16,start:1,dpth:8,end:4,att:0.25,rls:0.75]);
15.wait;
d = Synth(\fm, [harm:1, dur:16,start:4,dpth:12,end:2,att:0.75,rls:0.25]);
15.wait;
x = Routine.run({ loop({ Synth(\fm,[harm: 1, start: 16.rand.postln, depth:
16.rand.postln, end: 16.rand.postln]); 3.wait }) });
48.wait;
x.stop(1);
2.wait;
y = Routine.run({ loop({ Synth(\fm,[harm: 2, start: 16.rand.postln, depth:
16.rand.postln, end: 16.rand.postln]); 3.wait }) });
48.wait;
y.stop(1);
3.wait;
k = Synth(\fm, [harm:1, dur:8,start:1,dpth:8,end:6,att:0.5,rls:0.5]);
7.wait;
m = Synth(\fm, [harm:3, dur:8,start:3,dpth:6,end:1,att:0.25,rls:0.75]);
7.wait;
k = Synth(\fm, [harm:4, dur:8,start:1,dpth:8,end:6,att:0.5,rls:0.5]);
7.wait;
a = Synth(\fm, [harm:1, dur:32,start:3,dpth:16,end:1,att:0.25,rls:0.75]);
});
)
// happens
r.play;