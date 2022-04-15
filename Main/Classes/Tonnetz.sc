Tonnetz {
	var <>home, <>currChord, <>voiceLeading;
	/*var <>tr = \p;*/

	*new { | home, currChord, voiceLeading = 1 | // if voiceLeading == 1, chords are voice led; voiceLeading 0 currently unavailable
		^super.newCopyArgs(home, currChord, voiceLeading);
	}

	transform { | transform | // transform is a symbol made up of one or more transformation commands
		var chordQuality, chordIndices;
		chordQuality = ChordFunc.analyze(currChord)[1];
		transform.asString.do({ |keyChar|
			switch(keyChar,
				$p, { // moves the 3rd up and down (e.g., C<->Cm)
					chordIndices = ChordFunc.findIndices(currChord, 1);
					switch(chordQuality,
						"Major", { chordIndices.do{ |index| currChord[index] = currChord[index] - 1 } },
						"Minor", { chordIndices.do{ |index| currChord[index] = currChord[index] + 1 } }
					);
					"p".postln;
				},
				$r, { // moves the 5th up if major, root down if minor (e.g., C<->Am/C)
					switch(chordQuality,
						"Major", { chordIndices = ChordFunc.findIndices(currChord, 2);
							chordIndices.do{ |index| currChord[index] = currChord[index] + 2 } },
						"Minor", { chordIndices = ChordFunc.findIndices(currChord, 0);
							chordIndices.do{ |index| currChord[index] = currChord[index] - 2 } }
					);
					"r".postln;
				},
				$l, { // moves the root down if major, 5th up if minor (e.g., C<->Em/B)
					switch(chordQuality,
						"Major", { chordIndices = ChordFunc.findIndices(currChord, 0);
							chordIndices.do{ |index| currChord[index] = currChord[index] - 1 } },
						"Minor", { chordIndices = ChordFunc.findIndices(currChord, 2);
							chordIndices.do{ |index| currChord[index] = currChord[index] + 1 } }
					);
					"l".postln;
				},
				$h, {
					currChord = home;
					"h".postln;
				}
			);
		});

		ChordFunc.toSymbol(currChord).postln;
		^currChord;
	}
}