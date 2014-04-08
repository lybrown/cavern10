>>> open $fh, "all.bin.lz4" or die "ERROR: Cannot open all.bin: $!\n";
>>> read $fh, $bin, 999999;
>>> @parts = 
i=adr("")
o=$4800

while mo
  ? 0;
  mo=dpeek(i)
  l=peek(i+1)
  rl=l and 15
  ml=l div 16
  i=i+2
  if rl=15:rl=peek(i):i=i+1:endif
  if ml=15:ml=dpeek(i):i=i+2:endif
  move(i,o,rl)
  i=i+rl
  o=o+rl
  move(o-mo,o,ml+4)
  o=o+ml+4
wend
