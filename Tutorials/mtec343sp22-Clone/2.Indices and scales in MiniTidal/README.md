# Advanced MiniTidal

## But first...
  - [Glitch Lich](https://www.youtube.com/watch?v=6oVeKI4q9C0)
  - [OFFAL at ICLC 2016](https://www.youtube.com/watch?v=zmtLDbWXNeI&feature=emb_logo)

### Reading:
- "Network-Facilitated Composer Autonomy" - Knotts
  - "Valuing individual composers' autonomy without formally acknowledging the social structure that supports their creation conforms to traditional musical hierarchies."
- Communications
  - Glitch Lich: interactions facilitated by technology is important, not technology itself.
- Multiplayer
  - Critique of NOMADS
- "Pressure of traditional musical values"

## more MiniTidal!
### periodic oscillators

`sine`

`cosine`

`square`

`tri`

`saw`

`isaw`

### mix

`# pan`

`# gain`

**eg**

`# pan sine`

`# gain 0.5`

### sound bank indicies
- All the current sound bank/sample libraries are [here](https://docs.google.com/spreadsheets/d/1WduJ0yJVPeSmMkhxi5GewBPAFwOp5Hs8xeOhGs0J33g/edit?usp=sharing).
- `n` for iNdex (or Note, just for yourself)
- if you give a certain number of events and a different number to use for those events from the index, it will try and even it out.

- TODO add Carl's excellent sound bank stuff:
https://carltesta.github.io/vcsl_for_estuary/
https://carltesta.github.io/tahti_for_estuary/

**eg**

`s "drum:0 drum:1 drum:2 drum:3"` = play drum sample with first index, then second, then third, etc or

`s "drum*4" # n "0 1 2 3"` = sounds same

`s "drum*4" # n "5 6 7"` = even

### notes & scales
`note "0 2/2 4/3 7/4 9/5 11/6" # s "moog"` = as an index

`note "c d/2 e/3 g/4 a/5 b/6" # s "moog"` = as a scale, sounds the same

`note (scale "bartok" "0 2/2 4/3 7/4 9/5 11/6") # s "moog"`

#### all the scales
`minPent majPent ritusen egyptian kumai hirajoshi iwato chinese indian pelog prometheus scriabin gong shang jiao zhi yu whole augmented augmented2 hexMajor7 hexDorian hexPhrygian hexSus hexMajor6 hexAeolian major ionian dorian phrygian lydian mixolydian aeolian minor locrian harmonicMinor harmonicMajor melodicMinor melodicMinorDesc melodicMajor bartok hindu todi purvi marva bhairav ahirbhairav superLocrian romanianMinor hungarianMinor neapolitanMinor enigmatic spanish leadingWhole lydianMinor neapolitanMajor locrianMajor diminished diminished2 chromatic`
### chords
`note (arp "updown" "<a'min7 e'dom7>") # s "moog"`
#### all the chords
`major maj aug plus sharp5 six 6 sixNine six9 sixby9 6by9 major7 maj7 major9 maj9 add9 major11 maj11 add11 major13 maj13 add13 dom7 dom9 dom11 dom13 sevenFlat5 7f5 sevenSharp5 7s5 sevenFlat9 7f9 nine eleven 11 thirteen 13 minor min diminish ed dim minorSharp5 msharp5 mS5 minor6 min6 m6 minorSixNine minor69 min69 minSixNine m69 mSixNine m6by9 minor7flat5 min7f lat5 m7flat5 m7f5 minor7 min7 m7 minor7sharp5 min7sharp5 m7sharp5 m7s5 minor7flat9 min7flat9 m7flat9 m7f9 minor7sharp9 m in7sharp9 m7sharp9 m7s9 diminished7 dim7 minor9 min9 m9 minor11 min11 m11 minor13 min13 m13 one 1 five 5 sus2 sus4 seven Sus2 7sus2 sevenSus4 7sus4 nineSus4 ninesus4 9sus4 sevenFlat10 7f10 nineSharp5 9s5 m9sharp5 m9s5 sevenSharp5flat9 7s5f9 m7sharp5flat9 elevenSharp 11s m11sharp m11s`
#### all the arpeggiators
`up down updown downup converge diverge disconverge pinkyup pinkyupdown thumbup thumbupdown`
### time

`slow 2 $ note "c'maj7 f'maj7" # s "moog"` = halftime

`fast 2 $ note "c'maj7 f'maj7" # s "moog"`= doubletime

`every 3 (fast 2) $ note "c'maj7 f'maj7" # s "moog"` = every third cycle, doubletime

`every 2 (rev)  $ s "[bd*3] ~ hh*2"` = every second cycle, reverse the pattern

#### time **in terminal!!!**
`!setbpm 90` = change the bpm of bno

## to go EVEN further
- Take a look at the [TidalCycles documentation here](https://tidalcycles.org/docs/reference/), and cross reference it with the definitions in [this Haskell file](https://github.com/dktr0/estuary/blob/dev/client/src/Estuary/Help/MiniTidal.hs) that is up-to-date with what MiniTidal is capable of in Estuary.

## and finally, [the Discord](https://discord.gg/TfUy2MvBaX)

## For next week:
  - Performance and presentation time scheduled
