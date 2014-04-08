>>> open $fh, "mem.bin.lz4ish" or die "ERROR: Cannot open mem.bin.lz4ish: $!\n";
>>> binmode $fh;
>>> read $fh, $bin, 999999;
>>> $count = length $bin;
>>> $bin =~ s/"/""/g;
>>> $bin =~ /[:\x{9b}]/ and die "ERROR: Data contains 0x9B\n";
>>> $max = 227;
>>> @parts = unpack "(a$max)*", $bin;
>>> $p = 0;
>>> for $i (0 .. $#parts) {
>>>   $part = $parts[$i];
>>>   $quotecount = ($part =~ tr/"/"/) / 2;
move adr("<<<$part>>>"),<<<0xA000+$p>>>,<<<length($part)-$quotecount>>>:
>>>   $p += length($part) - $quotecount;
>>> }
i=$A000:
o=$4800:
while i< <<<0xA000+$count>>>:
>>> #  ? hex$(i);".";hex$(o);".";:
  ?0;:
  l=peek(i):
  mo=dpeek(i+1):
  rl=l div 16:
  ml=l & 15:
  i=i+3:
  if rl=15:
    :
    rl=peek(i):
    i=i+1:
  endif:
  if ml=15:
    ml=dpeek(i):
    i=i+2:
  endif:
>>> #  ? hex$(l);".";hex$(mo);".";hex$(rl);".";hex$(ml):
  move i,o,rl:
  i=i+rl:
  o=o+rl:
  move o-mo,o,ml+4:
  o=o+ml+4:
wend:
>>> #close #0:
pause 0:
>>> @antic = (
>>> 0x3D, # DMACTL
>>> 2, # CHACTL
>>> 0xD0, # DLISTL
>>> 0x49, # DLISTH
>>> 0, # HSCROL
>>> 0, # VSCROL
>>> 0, #
>>> 0x48, # PMBASE
>>> 0, #
>>> 0x48, # CHBASE
>>> 0, # WSYNC
>>> 0, # VCOUNT
>>> 0, # PENH
>>> 0, # PENV
>>> 0, # NMIEN
>>> );
move adr("<<<join "",map chr,@antic>>>"),$D400,<<<scalar @antic>>>:
>>> @gtia = (
>>> 0x78, # HPOSP0
>>> 0x00, # HPOSP1
>>> 0x20, # HPOSP2
>>> 0xC0, # HPOSP3
>>> 0x40, # HPOSM0
>>> 0xBF, # HPOSM1
>>> 0x00, # HPOSM2
>>> 0x00, # HPOSM3
>>> 1, # SIZEP0
>>> 0, # SIZEP1
>>> 3, # SIZEP2
>>> 3, # SIZEP3
>>> 0, # SIZEM
>>> 0, # GRAFP0
>>> 0, # GRAFP1
>>> 0, # GRAFP2
>>> 0, # GRAFP3
>>> 0, # GRAFM
>>> 0x88, # COLPM0
>>> 0x88, # COLPM1
>>> 0x44, # COLPM2
>>> 0x44, # COLPM3
>>> 0x44, # COLPF0
>>> 0x88, # COLPF1
>>> 0x2A, # COLPF2
>>> 0x26, # COLPF3
>>> 0, # COLBAK
>>> 0x24, # PRIOR
>>> 0, # VDELAY
>>> 3, # GRACTL
>>> );
move adr("<<<join "",map chr,@gtia>>>"),$D000,<<<scalar @gtia>>>:
    :
do:
s=$5000:
x=100:
sound 0,0,10,10:
poke $D01E,0:
repeat:
    v=v+1:
    if v=16:v=0:s=s+32:endif:
    while peek($d40b)<100:wend:
    poke $D405,v:
    dpoke $49D1,s:
    :
    j=peek($D300):
    x=x+(j=$F7)-(j=$FB):
    poke $D000,x:
    move $49E3+v,$D200,1:
until peek($D004) or peek($D00C):
sound 0,8,0,10:fori=0to999:nexti:
poke $D000,100:
loop:
