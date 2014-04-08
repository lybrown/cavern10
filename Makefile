mem.run:
mem.obx: all.bin pm.bin

test.run:
test.obx: rows.bin rows2.bin pm.bin scr.bin font.bin

all.bin: rows.bin rows2.bin scr.bin font.bin pm.bin ex.pl
	./ex.pl $(filter %.bin,$^) $(out)

all.bin.lz4: all.bin
	lz4 -f -9 $< $@

all.bin.lz4ish: all.bin.lz4
	lz4 -f -d $< dummy
	mv side.lz4ish $@

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

%.asm: %.asm.pl
	perl $< $(out)
	
%.obx: %.asm
	#mads -t:$*.lst -l:$*.listing $<
	xasm /t:$*.lab /l:$*.lst $<
	perl -pi -e 's/^n /  /' $*.lab

clean:
	rm -f *.{obx,lst,listing,xex,asm.pl} *~

.PRECIOUS: %.obx %.atr %.xex %.asm
