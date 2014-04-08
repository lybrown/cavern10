    icl 'hardware.asm'
scr equ $2000
pm equ $3000
ch equ $3800
rows equ $3C00

    org $80
rowptr org *+2
rowinc org *+2
freqptr org *+1

    org pm+$300
    ins 'pm.bin'
    org ch
    ins 'font.bin'
    org scr
    ins 'scr.bin'
    org rows
    ins 'rows.bin',0,$200
    ins 'rows2.bin',$200,$100

    org $1000
dlist
    :15 dta $65,a(scr)
    dta $41,a(*)
freqtable
    dta $70,$71,$72,$73,$74,$73,$72,$71
freqtable2
    dta $4B,$55,$5F,$69
freqtable3
    dta $8D,$97,$A1,$AB
main
    sei
    mva #0 NMIEN
    lda:rne VCOUNT
    mwa #dlist DLISTL
    mva >ch CHBASE
    mva >pm PMBASE
    lda PORTB
    and #$FE
    sta PORTB
    mwa #frame NMIVEC
    mwa #rows rowptr
    mwa #0 freqptr
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

    ldy #0
>>> for $i (0 .. 14) {
    mva (rowptr),y dlist+1+<<<$i*3>>>
    iny
    mva (rowptr),y dlist+2+<<<$i*3>>>
    iny
>>> }
    mwa #0 rowinc
    lda PORTA
    lsr @
    scs:mwa #-2 rowinc
    lsr @
    scs:mwa #2 rowinc
    lda rowinc
    add:sta rowptr
    lda rowinc+1
    adc:sta rowptr+1

    mwa #dlist DLISTL

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
