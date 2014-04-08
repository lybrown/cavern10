    icl 'hardware.asm'
font equ $4800
pm equ $4800
scr equ $5000
dlist equ font+$1D0

    org $80
rowptr org *+2
rowinc org *+2
freqptr org *+1
vfine org *+1

    ift 1
    org font
    ins 'all.bin',0,$400
    org pm+$300
    :233-16 dta $0A
    org pm+$400
    ins 'pm.bin',$100,$100
    org pm+$600
    :233-16 dta $FF
    org pm+$700
    :233-16 dta $FF
    org scr
    ins 'all.bin',$400

    org dlist
    dta $65,a(scr)
    :12 dta $25
    dta $5
    dta $41,a(dlist)
freqtable3
    :4 dta $8D,$97,$A1,$AB

    els
    org font
    ins 'mem.bin'
    eif

    org $1000
freqtable
    dta $70,$71,$72,$73,$74,$73,$72,$71
freqtable2
    :4 dta $4B,$55,$5F,$69
main
    sei
    mva #0 NMIEN
    lda:rne VCOUNT
    mwa #dlist DLISTL
    mva >font CHBASE
    mva >pm PMBASE
    lda PORTB
    and #$FE
    sta PORTB
    mwa #frame NMIVEC
    mwa #0 freqptr
    sta vfine
    mva #$40 NMIEN
    mva #$3D DMACTL
    mva #2 CHACTL
    mva #3 GRACTL
    mva #$24 PRIOR
    mva #$44 COLPF0
    mva #$88 COLPF1
    mva #$2A COLPF2
    mva #$26 COLPF3
    mva #$88 COLPM0
    mva #$88 COLPM1
    mva #$44 COLPM2
    mva #$44 COLPM3
    mva #$78 HPOSP0
    mva #$00 HPOSP1
    mva #$20 HPOSP2
    mva #$C0 HPOSP3
    mva #$40 HPOSM0
    mva #$BF HPOSM1
    mva #$00 HPOSM2
    mva #$00 HPOSM3
    mva #1 SIZEP0
    mva #0 SIZEP1
    mva #3 SIZEP2
    mva #3 SIZEP3
    mva #$A4 AUDC1
    jmp *
frame
    pha
    txa:pha
    tya:pha

    inc vfine
    lda vfine
    cmp #16
    bne scrolldone
    mwa #0 rowinc
    sta vfine
    lda PORTA
    lsr @
    scs:mwa #-$20 rowinc
    lsr @
    scs:mwa #$20 rowinc
    lda rowinc
    add:sta dlist+1
    lda rowinc+1
    adc:sta dlist+2

scrolldone
    mva vfine VSCROL

    ;mwa #dlist DLISTL

    ldx freqptr
    mva freqtable3,x AUDF1
    inx
    txa
    and #$3
    sta freqptr

    pla:tax
    pla:tay
    pla
    rti
    rti
    run main
