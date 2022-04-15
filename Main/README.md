# BNO_DNA/Main
Main file for program

## Brainstorm.md
self explanatory. file for spitballing and documenting various ideas about the project.

## Main.scd
main Supercollider File. May compartmentalize at some point, but that's a step for once the composition is a bit more fleshed out

## Classes
Tonnetz Externals, must be installed at designated path in Tonnetz readme

## Samples
Filedump for any samples being used

## Synths
parent file for SynthLibrary.scd, the library called within Main.Supercollider

## Testing
Test Files and Deprecated Code. It is best practice to not edit Main.scd Directly, but rather to copy it into this folder and copy it back when the implementation works, as not to overwrite a functioning Main.scd

## TwitterScraping

Python Module Performing Twitter API Scraping. Must be called in order for Main.scd to run correctly


# STEPS TO RUN THUMB

## 1. Open Terminal, set working directory TwitterScraping File

`{path}\BNO_DNA\Main\TwitterScraping`

## 2. Run Code `python3 main.py` you may have to install a few packages in order for code to run properly

## 3. Open main.scd
(rest of setup process takes place within main.scd)

### 4. Boot SC server

### 5. Run ServerTree loader code to boot SynthLibrary to the ServerTree

### 6. Run OSC Function Code in SC. You've done it correctly when Data is posting in the console

### 7. Run Sentiment LFO (currently not working, but still necessary to be present for Pbinds

### 8. Run Pbind code. Currently the Pbind must be re-triggered to generate new melodies based off of incoming data. A fix is in the works to rectify this, so that the composition evolves on its own.
