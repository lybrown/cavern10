dev: tb.ltb
	-franny -U GAME.LST dev.atr
	franny -A -i tb.ltb -o GAME.LST dev.atr
	altirra dev.atr

tb.lst: mem.bin.lz4ish

mem.run:
mem.obx: all.bin pm.bin

test.run:
test.obx: rows.bin rows2.bin pm.bin scr.bin font.bin

all.bin: rows.bin rows2.bin scr.bin font.bin pm.bin ex.pl
	./ex.pl $(filter %.bin,$^) $(out)

mem.bin.lz4: mem.bin /home/lybrown/bin/lz4.exe
	lz4 -f -9 $< $@

mem.bin.lz4ish: mem.bin.lz4
	lz4 -f -d $< dummy
	mv side.lz4ish $@
%.ltb: %.lst lst2ltb
	./lst2ltb $< $(out)

SHELL=bash
dude.asm: dude.png
	echo $$(convert.exe $< -compress none pbm:/dev/stdout | grep -A1000 ^1 ) \
	| perl -ne '@x=split;while(@x){@y=(splice(@x,0,41),0,0,0,0,0,0,0); print " dta ";while(@y){@z=splice@y,0,8; print join "","0b",@z,","}print "\n";}' \
	$(out)

out = > $@~ && mv $@~ $@

atari = altirra

%.run: %.xex
	$(atari) $<

%.xex: %.obx
	cp $< $@

%.boot: %.atr
	$(atari) $<

%.atr: %.obx obx2atr
	./obx2atr $< $(out)

%.asm.pl: %.asm.pp
	echo 'sub interp {($$_=$$_[0])=~s/<<<(.*?)>>>/eval $$1/ge;print}' > $@
	perl -pe 's/^\s*>>>// or s/(.*)/interp <<'\''EOF'\'';\n$$1\nEOF/;' $< >> $@

%.lst.pl: %.lst.pp
	echo 'sub interp {($$_=$$_[0])=~s/<<<(.*?)>>>/eval $$1/ge;print}' > $@
	perl -pe 's/^\s*>>>// or s/(.*)/interp <<'\''EOF'\'';\n$$1\nEOF/;' $< >> $@

%.asm: %.asm.pl
	perl $< $(out)
	
%.lst: %.lst.pl
	perl $< $(out)
	
%.obx: %.asm
	#mads -t:$*.lst -l:$*.listing $<
	xasm /t:$*.lab /l:$*.lst $<
	perl -pi -e 's/^n /  /' $*.lab

clean:
	rm -f *.{obx,lst,listing,xex,asm.pl} *~

.PRECIOUS: %.obx %.atr %.xex %.asm
