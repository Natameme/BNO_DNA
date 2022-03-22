# Patterns in MiniTidal

## Housekeeping
- Are we all good with April 29?
- Headphone check
- Atom downloaded and installed
- We *do* have a class tutor
- Would you like a class Discord?

## [Estuary](https://estuary.mcmaster.ca/)
- Sandbox
- What's great
  - so accessible
- What's not so great
  - limited functionality
- [Estuary Discord](https://discord.com/invite/snvFzkPtFr)
  - BNO/mtec343

## But first...
      - [PLOrk](http://plork.deptcpanel.princeton.edu/listen/NYC/)

### Reading:
  - "Sonic Presence and Performative Attention" - Trueman
    - Localisation
    - Virtuousity
    - Performance practice
    - "Tinkering"
  - "Conducting the Laptop Orchestra"
    - "Responsive Battleship"
  - '"as far as I could tell, they were all just checking their email"'

## MiniTidal
- Everything is pattern-based
- Based on [TidalCycles](https://tidalcycles.org/)
  - In TidalCycles everything is pattern-based, too
  - Audio engine is SuperDirt/SuperCollider
- Use the samples in the sandbox (we'll get to more complicated samples later)
### starter drum samples
`bd sd hh ho hc lt ht mt cp`
### starter pattern commands and syntax
`s` = sound

`" "` = what to fit inside one cycle

`~` = silence

`*` = repeat

`"[ ] "` = what to fit inside one pulse within one cycle

**starter examples**

`s "bd"`

`s "bd hh"`

`s "bd ~ hh"`

`s "bd ~ hh*2"`

`s "[bd*3] ~ hh*2`

**everybody now in solo mode**

**everybody now in BNO**

### more advanced commands and syntax

`,` = layer these atop one another within one pulse

`/` = play every second, third, fourth cycle (as specified with integer)

`|` = randomly choose sample from this list

`<>` = choose one sample from

`?` = random silence

**more examples**

`s "[bd sd, hh hh]"`

`s "bd sd/2 hh/2"`

`s "[bd | sd | hh]"`

`s "<bd sd hh>"`

`s "hh*16?"`

**everybody now in solo mode**

**everybody now in BNO**

### euclidean and polymetric rhythms

`( , )` = spread this many pulses over this many pulses per cycle

`{ , }` = this pattern against this pattern per cycle

**even more examples**

`s "bd(7,12)"`

`s "{bd bd bd bd, cp cp hh}"`

### stacks

`stack [s " ",
s " "]`

**stacks of examples**

`stack [s "bd(7,12)",
s "{bd bd bd bd, cp cp hh}"]`

**everybody now in solo mode**

## For next week:
- Practice your MiniTidal in solo mode in Estuary!
- Read:
  - Knotts-Changing.pdf
  - Outline as markdown in your GitHub repo
- Never forget! HEADPHONES NEXT WEEK AND ALWAYS
