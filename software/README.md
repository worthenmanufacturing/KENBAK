#KENBAK-1 Software

Software was written and assembled using the KENBAK IDE by 
kidmirage
[https://github.com/kidmirage/KENBAK-2-5-Build-Files](https://github.com/kidmirage/KENBAK-2-5-Build-Files).

An updated version with some fixes is available at
[https://github.com/worthenmanufacturing/KENBAK-2-5-Build-Files](https://github.com/worthenmanufacturing/KENBAK-2-5-Build-Files).

It requires Tkinter and Python3.

## Simon

An implementation of the Simon Says game for the KENBAK-1

To play:
   o At startup, the lights flash and then a countdown
     sequence of the lights occurs (this is the previous
     sequence being cleared).

   o Press a BitN button when you're ready to play.

   o Repeat the displayed sequence. 


After your first round, the high score is displayed in
binary.

Note: Playing at speed Bit4 seems to be reasonable.


Known issues:
    o When the same light occurs sequentially, there's
      not enough of a delay to flash it properly
    o Current maximum number of lights in the sequence
      is 17 - after that it will crash (no limit checking
      is done).

