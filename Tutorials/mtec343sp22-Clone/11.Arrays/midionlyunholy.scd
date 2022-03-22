(
r = Routine ({

//lower tetrachord A

a = Pbind(
\midinote, Prand([40, 41, 43], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

12.wait;

//lower tetrachord B 12"

b = Pbind(
\midinote, Prand([50, 52, 53, 55], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

12.wait;

//lower tetrachord C 24"

c = Pbind(
\midinote, Prand([62, 64, 65, 67], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

12.wait;

//upper tetrachord C 36"

d = Pbind(
\midinote, Prand([69, 71, 72, 74], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

12.wait;

//upper tetrachord A 42"

f = Pbind(
\midinote, Prand([47, 48, 50], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

12.wait;

//lower tetrachord E 54"

g = Pbind(
\midinote, Prand([86, 88, 89, 91], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

60.wait;

// A Drone in 32' pipe 1:54

e = Pbind(
	\delta, 0.25,
	\midinote, 45,
).play;

12.wait;

//lower tetrachord D 2:06

h = Pbind(
\midinote, Prand([74, 76, 77, 79], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

12.wait;

//upper tetrachord B 2:18

i = Pbind(
\midinote, Prand([57, 59, 60, 62], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

12.wait;

//upper tetrachord D 2:30

k = Pbind(
\midinote, Prand([81, 83, 84, 86], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

12.wait;

//upper tetrachord E 2:42

l = Pbind(
\midinote, Prand([93, 95, 96], inf),
\dur, Prand([4, 2, 1, 0.5], inf)
).play;

120.wait;

// D Drone in 32' pipe 4:42

j = Pbind(
	\delta, 0.25,
	\midinote, 38,
).play;


90.wait;

i.stop;
12.wait;
k.stop;
12.wait;
l.stop;
12.wait;
g.stop;
12.wait;
h.stop;
12.wait;
d.stop;
12.wait;
f.stop;
12.wait;
a.stop;
12.wait;
b.stop;
12.wait;
c.stop;
12.wait;
e.stop;
12.wait;
j.stop;
});
)


r.play
