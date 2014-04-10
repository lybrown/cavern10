Cavern 10
=========

10-lines of Atari Turbo Basic:

    0M.ADR("*********XZVUUU ***h*********UUUwwww*UUU*]*]*U***V""*****P***=*******|*****P***jZV*p****jV**************<<*hS*****jV*W**c****ZXh*Z****)***********UU****p*******)%#**U*@***%********6p***h18**hZa8******)******cP**)****2H**"),$A000,219
    1M.ADR("**c(***********UUVVj***VZ******UUP@*UAUU(***@PUU***V*e***f3********Y****@****************?*****C*********************?****#****************e*P%****A*IKU_i********U**=**IH****** *@***********t***DDD**&*$***pqrstsrq***J***"),$A0DB,220
    2M.ADR("********=********<<ff~~*************************o *****************************&*_ *********&*/ ********* ******/**b******/*********+****R**************4***** ****** *.*********/******o**********!****?*******%*** *f**'**"),$A1B7,220
    3M.ADR("*****!/**C*""#******/******* *******? ***$%&*""***/""*****/""***********@*9***""*/""*****/""*****/""*****/""*****/""********""**z**********************H*******~****g***L********************<****V** *P****.****/""*****O**"),$A293,208
    4M.ADR("**!'(*******>*********!***********/,*&***?V*%*)*+***\**B*$*/**l****J**V**t*P**~***/**&***********3**x******k**/@*2***/**\****`*j*/.*H*********x******/**|**********P****9****-****n**(****""****f*/**B***********/X*<***/**t"),$A363,219
    5M.ADR("****B***/**~************{**6**D*J*/L******h*7*/***************~*f**|****e******O****,,,-o ***.///01/ ***01*****,******/D***01*<** ******)**./*$** ***** *D*O ***2345O ***6789***/**_*01***"),$A43E,186:I=$A000:O=$4800:W.I<$A4F8
    6?0;:L=PEEK(I):MO=DPEEK(I+1):R=L DIV16:M=L&15:I=I+3:IFR=15:R=PEEK(I):I=I+1:END.:IFM=15:M=DPEEK(I):I=I+2:END.:M.I,O,R:I=I+R:O=O+R:M.O-MO,O,M+4:O=O+M+4:WE.:PA.0:M.$4A03,$D400,15
    7M.$4A12,$D000,31:DO:V=0:POKE$D01E,0:S=$5000:X=100:SO.0,0,10,6:REP.:V=V+1:IFV=16:V=0:S=S+32:END.:J=PEEK($D300):X=X+(J=$F7)-(J=$FB):W.PEEK($D40B)<82:WE.
    8DP.$49D1,S:POKE$D405,V:POKE$D000,X:M.$49E3+V,$D200,1:M.$49F3+V,$D018,1:U.PEEK($D004)ORPEEK($D00C):IFS>=$76E0:F.I=0TO128:M.$4A31+I,$D200,1:W.PEEK($D40B)>12:WE.:N.I
    9EL.:SO.0,48,0,15:END.:F.I=0TO999:N.I:POKE$D000,0:LOOP

(Non-printable characters have been replaced with "\*".)

Features
--------

* Over 12K of game data compressed into 1272 bytes in slighty modified LZ4 format
* Unpacker takes about one line. (line 6)
* Full frame rate

Limitations
-----------

* No weapons, so it's reduced to just navigating past obstacles

Download
--------

* [Cavern10.atr](https://github.com/lybrown/cavern10/raw/master/Cavern10.atr) (PAL)
* [Cavern10-NTSC.atr](https://github.com/lybrown/cavern10/raw/master/Cavern10-NTSC.atr) (NTSC, no sound or animation)

Links
-----

* [Caverns of Mars](http://www.atarimania.com/game-atari-400-800-xl-xe-caverns-of-mars_11567.html)
* [lz4](https://code.google.com/p/lz4/)
