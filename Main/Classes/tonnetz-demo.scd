a = Tonnetz([0, 4, 7], [0, 4, 7]); // initialize a Tonnetz with a C major triad

// available transform keywords are: \p (parallel), \r (relative), \l (leading tone), and \h (home) or any combination of the above (e.g., \pr would output a chord after both parallel and then relative transformations) (combination currently doesn't work for some reason)
a.transform(\p); // this works
a.transform(\rp); // doesn't work for some reason

