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

while mo
  ? 0
  mo=dpeek(i)
  l=peek(i+1)
  rl=l and 15
  ml=l div 16
  if rl=15:rl=peek(i+2):i=i+1:endif
  if ml=15:ml=dpeek(i+2):i=i+2:endif
  move(i+2,o,rl)
  i=i+2+rl
  o=o+rl
  move(o-mo,o,ml)
  o=o+ml
wend

while mo:mo=dpeek(i):l=peek(i+1):rl=l and 15:ml=l div 16:if rl=15:rl=peek(i+2):i=i+1:endif:if ml=15:ml=dpeek(i+2):i=i+2:endif:move(i+2,o,rl):i=i+2+rl:o=o+rl:move(o-mo,o,ml):o=o+ml:wend
