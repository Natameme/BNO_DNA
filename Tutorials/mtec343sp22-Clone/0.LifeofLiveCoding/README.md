# The Life of Live Coding

## Who are you?

## What do you know about Live Coding?

## DTR: Live Coding
- Improviser messes with inner workings of digital electronics as they make art in real-time
  - Audio - Visual
  - (Not a controller)
- Laptopists: solo and ensemble contexts
- Many anti-hierarchical political meanings buried in historical practices
  - Open Source culture
  - (against propriety software, hoarding tools + knowledge)
  - distributed agency
  - Luthier/developer/backend, performer/musician/frontend roles
  - Bespoke/DIY/homebrewed

## Who am I?
- improviser
- mind blown by early [PLORK](http://plork.deptcpanel.princeton.edu/listen/NYC/), late [The HUB](http://crossfade.walkerart.org/brownbischoff/)/The Bisch/Chris Brown concerts
- public librarian + database programmer (SQL)
- distributed agency, open access
- sc
- offal
- testa/devorah

## What are we going to do here and how are we going to do it?
- Big Picture
- Nitty Gritty

## But first...
  - [League of Automatic Music Composers 1980](https://acousmata.com/post/893801464/martian-folk-music)

## [Estuary](https://estuary.mcmaster.ca/)
- Sandbox
- What's great
- What's not so great

## For next week:
  - Setup your own dedicated GitHub repository for course materials
  - Download and install:
  - [Atom](https://atom.io/) with SuperCollider, Hydra, and Tidal packages installed
  - [SuperCollider 3.12](https://supercollider.github.io/)(SC)
  - [Python 3](https://www.python.org/downloads/)
  - Read:
    - Trueman-Why.pdf
    - Outline as markdown in your GitHub repo
  - Bring HEADPHONES NEXT WEEK!

## [MiniTidal for Estuary](https://github.com/carltesta/workshops/blob/main/minitidal_reference.md)

## MiniTidal MiniPerformance

`drum:

percknock fire birds birds3 cosmic // rdwr fav samples

s "percknock*7" # n "0 1 2 3 4 5" // 7 over 4 with a 6 sound sequence loop

s "percknock*7" # n (irand 7) // 7 over 4 with 7 random sounds

s "percknock(7, 12)" # n (irand 7) // 7 over 12 with 7 random sounds

s "percknock*7?" # n (irand 6),
stack [note (arp "discoverge" "<a'min7 e'dom7>") # s "birds3",
s "fire*7?" # n (irand 6),
note (arp "coverge" "<a'min7 e'dom7>") # s "birds"]

stack [note (arp "discoverge" "<a'min7 e'dom7>") # s "birds3",
s "cosmicg*7?" # n (irand 6),
note (arp "coverge" "<a'min7 e'dom7>") # s "birds",
s "cosmicg*5" # n "0 1 2 3 4 5"]

arp:

note (arp “converge” "<a'min7 e'dom7>") # s "gtr"

stack [note (arp "discoverge" "<a'min7 e'dom7>") # s "moog",
s "[bd sd]*2", s "hh*16?",
note (arp "coverge" "<a'min7 e'dom7>") # s "moog"]

stack [s "percknock(7, 12)" # n (irand 7) # gain 1,
note (arp "disconverge" "<a'minorSixNine e'm7s9>") # s "moog" # gain 0.8]

converge diverge disconverge pinkyup pinkyupdown

major maj aug plus sharp5 six 6 sixNine six9 sixby9 6by9 major7 maj7 major9 maj9 add9 major11 maj11 add11 major13 maj13 add13 dom7 dom9 dom11 dom13 sevenFlat5 7f5 sevenSharp5 7s5 sevenFlat9 7f9 nine eleven 11 thirteen 13 minor min diminish ed dim minorSharp5 msharp5 mS5 minor6 min6 m6 minorSixNine minor69 min69 minSixNine m69 mSixNine m6by9 minor7flat5 min7f lat5 m7flat5 m7f5 minor7 min7 m7 minor7sharp5 min7sharp5 m7sharp5 m7s5 minor7flat9 min7flat9 m7flat9 m7f9 minor7sharp9 m in7sharp9 m7sharp9 m7s9 diminished7 dim7 minor9 min9 m9 minor11 min11 m11 minor13 min13 m13 one 1 five 5 sus2 sus4 seven Sus2 7sus2 sevenSus4 7sus4 nineSus4 ninesus4 9sus4 sevenFlat10 7f10 nineSharp5 9s5 m9sharp5 m9s5 sevenSharp5flat9 7s5f9 m7sharp5flat9 elevenSharp 11s m11sharp m11s`
