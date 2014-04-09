>>> sub hx { sprintf "\$%x", $_[0] }
>>> open $fh, "mem.bin.lz4ish" or die "ERROR: Cannot open mem.bin.lz4ish: $!\n";
>>> binmode $fh;
>>> read $fh, $bin, 999999;
>>> $count = length $bin;
>>> $bin =~ s/"/""/g;
>>> $bin =~ /[:\x{9b}]/ and die "ERROR: Data contains 0x9B\n";
>>> $max = 220;
>>> @parts = unpack "(a$max)*", $bin;
>>> $p = 0;
>>> for $i (0 .. $#parts) {
>>>   $part = $parts[$i];
>>>   $quotecount = ($part =~ tr/"/"/) / 2;
>>>   $len = length($part) - $quotecount;
move adr("<<<$part>>>"),<<<hx(0xA000+$p)>>>,<<<$len>>>:
>>>   $p += $len;
>>> }
>>> # Decompress LZ4-ish data
i=$A000:
o=$4800:
while i< <<<hx(0xA000+$count)>>>:
>>> #  ? hex$(i);".";hex$(o);".";:
  :
  ?0;:
  l=peek(i):
  mo=dpeek(i+1):
  r=l div 16:
  m=l & 15:
  i=i+3:
  if r=15:
    r=peek(i):
    i=i+1:
  endif:
  if m=15:
    m=dpeek(i):
    i=i+2:
  endif:
>>> #  ? hex$(l);".";hex$(mo);".";hex$(r);".";hex$(m):
  move i,o,r:
  i=i+r:
  o=o+r:
  move o-mo,o,m+4:
  o=o+m+4:
wend:
pause 0:
move $4A03,$D400,15:
:
move $4A12,$D000,31:
>>>#do:
>>>#v=0:
>>>#poke $D01E,0:
s=$5000:
x=100:
b=255:
sound 0,0,10,6:
repeat:
    v=v+1:
    j=peek($D300):
    i=(j=$F7)-(j=$FB):
    x=x+i:
    while peek($d40b)<110:wend:
    poke $D405,v:
    poke $D000,x:
    move $49E3+v,$D200,1:
    :
    if b<246:
        if peek($D005):
            move $4800,s+32*((b+v) div 16)+k-16,4:
            move $4800,$4D00+b,6:
            poke $D01E,0:
            b=255:
        else:
            -move $4DFC,$4D00+b,6:
            b=b+4:
        endif:
    else:
        if not peek($D010):
            b=40:
            k=x div 4:
            poke $D001,x+4:
        endif:
    :
    endif:
    v=v+1:
    if v=16:v=0:s=s+32:endif:
    while peek($d40b)<105:wend:
    poke $D405,v:
    x=x+i:
    poke $D000,x:
    dpoke $49D1,s:
    move $49E3+v,$D200,1:
    move $49F3+v,$D018,1:
until peek($D004) or peek($D00C):
:
sound 0,48,0,15:for i=0 to 999:next i:
>>>#poke $D000,0:
>>>#loop:
move $4AE0,$D000,31:
poke $D40E,$40:
graphics 0:
run:
