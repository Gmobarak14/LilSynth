<Cabbage> bounds(0, 0, 0, 0)
form caption("Lil' Synth") bundle("./imgs")size(450, 260), guiMode("queue"), pluginId("def1"), colour("brown") 
keyboard bounds(0, 170, 450, 89) channel("keyboard2")
image      bounds(-2, 18, 137, 92), colour(30, 70, 70, 255), , ,alpha(1)  channel("image0") file("./imgs/lilsynth.png")
image      bounds(0, 0, 450, 172), colour(30, 70, 70, 255), , , alpha(0.2) channel("image1") file("./imgs/redmetal.png")
groupbox bounds(200, 12, 68, 139) channel("groupbox10006") outlineColour(36, 36, 36, 255) 
groupbox bounds(112, 12, 68, 139) channel("groupbox10007") outlineColour(36, 36, 36, 255) 
groupbox bounds(288, 12, 68, 136) channel("groupbox10008") outlineColour(36, 36, 36, 255) 
groupbox bounds(370, 12, 65, 138) channel("groupbox10009") outlineColour(36, 36, 36, 255) 
groupbox bounds(20, 77, 60, 69) channel("groupbox10010") outlineColour(36, 36, 36, 255) 
rslider bounds(20, 82, 58, 61) channel("volume") range(0, 1, 0.5, 1, 0.001) text("Volume")  outlineColour(255, 255, 255, 255) colour(255, 255, 255, 255) trackerColour(157, 204, 47, 255)
rslider bounds(208, 18, 56, 61) channel("mix") range(0, 1, 0, 1, 0.001) text("Osc Mix") colour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(378, 82, 50, 63) channel("reverb") range(0, 1, 0.473, 1, 0.001) text("Reverb")  outlineColour(255, 255, 255, 255) colour(255, 255, 255, 255)
rslider bounds(376, 18, 54, 64) channel("delay") range(0, 1, 0.473, 1, 0.001) text("Delay") colour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(296, 82, 52, 61) channel("cutoff") range(100, 1500, 500, 1, 1) text("Cutoff") colour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(118, 18, 54, 63) channel("attack") range(0.01, 0.5, 0.1, 1, 0.001) text("Attack") colour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(120, 84, 54, 63) channel("release") range(0.1, 4, 0.4, 1, 0.1) text("Decay") colour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(296, 20, 52, 63) channel("pan") range(0, 1, 0.5, 1, 0.01) text("Pan") colour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(208, 82, 52, 63) channel("vibrato") range(0.4, 10, 1, 1, 0.01) text("OSC2 Vib") colour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
<CabbageIncludes>
lilsynth.png
redmetal.png
<CabbageIncludes>
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>



sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

ga1		init	0
ga2		init	0
ga3 	init 	0
ga4 	init	0

turnon 20
turnon 21


instr 1

kvol chnget "volume"
kmix chnget "mix"
kvrb chnget "reverb"
kdel chnget "chorus"
kfilt chnget "cutoff"
kpan chnget "pan"
krel chnget "release"

iamp ampmidi 	.2 
icps cpsmidi 

iplk = 0.4
kpick = 0.75
krefl = 0.4

katk chnget "attack"
kdel chnget "delay"

kenv	    mxadsr  i(katk),.2,.8,i(krel)

apluck wgpluck2 iplk, kenv*kvol, icps, kpick, krefl
apluck  dcblock2    apluck

       		
       				    
kpres = 5						;pressure value
krat = 0.5							;position along string
kvibf chnget "vibrato"
;kvibf = 0.5
;kvib  linseg 0, 0.5, 0, 1, 1, 2.5, 1			; amplitude envelope for the vibrato.	
kvib chnget "vibrato"	
kvamp = kvib * 0.01
abow  wgbow kenv*kvol, icps/2, kpres, krat, kvibf, kvamp, 1

amix ntrpol		apluck, abow, kmix


ares = rezzy(amix, kfilt, 1)
a1,a2 pan2 ares, kpan
outs a1, a2
   
vincr ga1, a1 * kvrb
vincr ga2, a2 * kvrb
vincr ga3, a1 * kdel
vincr ga4, a2 * kdel

   endin
   
   
     
		instr	20	
		denorm 	ga1, ga2
arevl,arevr  	reverbsc 	ga1, ga2, 0.9, 12000, sr, 0.5, 1
        	outs 		arevl, arevr
			clear 		ga1, ga2
	endin

    
   instr 21
denorm ga3,ga4
kdel cabbageGetValue "delay"
aDelL vdelay ga3, 400, 10000
aDelR vdelay ga4, 200, 10000
  outs aDelL * kdel, aDelR *kdel
ga3 += aDelL
ga4 += aDelR
   clear ga3, ga4
	
   
endin

</CsInstruments>
<CsScore>
f 1 0 2048 10 1
;         pluck   reflection
f 0 z 
;i 1 0 1     0       0.9
;i 1 + 1     <       .
;i 1 + 1     <       .
;i 1 + 1     1       . 

;i 1 5 5     .75     0.7 
;i 1 + 5     .05     0.7 
e
</CsScore>
</CsoundSynthesizer> 













