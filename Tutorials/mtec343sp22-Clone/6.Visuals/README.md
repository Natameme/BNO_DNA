# Visuals

## [Pipe Notation](https://github.com/supercollider/supercollider/wiki/Code-style-guidelines)

## [Do we want to play this on Tuesday?](https://livecodera.glitch.me/)
- Times are 6 hours ahead of Boston

## [Hydra]
- javascript-based
- [in-browser sandbox](https://hydra.ojack.xyz/?sketch_id=rangga_2)
- atom package (sc can also run as an atom package[not rachel's fav combination for livecoding anymore])
- estuary!
- plays well with tidal (what minitidal is based on, remember?)
- [Hydra on GitHub](https://github.com/hydra-synth/hydra)

### [Hydra Examples](https://github.com/hydra-synth/hydra-examples)
- roll through
- play with some parameters
- show and tell

### Favorite Features?
- webcam
- mouse control
- kaleidoscope
- pixelate

## SuperCollider > BlackHole > OBS for audio streaming
- ORDER OF OPERATIONS CRITICAL!
- **Audio MIDI Setup**
  - Input: BlackHole 16ch
  - Output: Multi-Output Device
    - BlackHole 16ch Use box checked!
- **SuperCollider**
  - Input: N/A
  - Output: BlackHole 16ch
  - If you need to change it run this then reboot server:
<pre>
  Server.default.options.outDevice_("BlackHole 16ch");
</pre>
- **OBS**
  - Main Window: Add Source to Scene
    - Audio Input Capture
    - Add Existing
        Mic/Aux (make source visible)
  - Preferences
    - Audio
      - Devices
        - Mic/Auxiliary Audio
          - BlackHole 16 ch
      - Monitoring Device
        - YOUR MONITORING DEVICE (external headphones, interface, etc)
  - Main Window: Audio Cog Image
      - Advanced Audio Properties
        - Audio Monitoring
          - Monitor Only
