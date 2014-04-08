i=adr("");
o=0xa000;

while mo
  rl=peek(i)
  ml=peek(i+1)+4
  mo=dpeek(i+2)
  move(i+4,o,rl)
  i=i+4+rl
  o=o+rl
  move(o-mo,o,ml)
  o=o+ml
wend

while mo:rl=peek(i):ml=peek(i+1)+4:mo=dpeek(i+2):move(i+4,o,rl):i=i+4+rl:o=o+rl:move(o-mo,o,ml):o=o+ml:wend
