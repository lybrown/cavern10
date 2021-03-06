    icl 'hardware.asm'
font equ $4800
pm equ $4800
scr equ $5000
dlist equ font+$1D0

    org $80
rowptr org *+2
rowinc org *+2
tick org *+1
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
    :4 dta $4B,$55,$5F,$69
pf2table
    :8 dta $0E
    :8 dta $2A
bullet
    ;dta $0A,$0A,$CA,$CA
antic
    dta $3D ; DMACTL
    dta $2 ; CHACTL
    dta $D0 ; DLISTL
    dta $49 ; DLISTH
    dta $48 ; HSCROL
    dta $48 ; VSCROL
    dta $48 ; --
    dta $48 ; PMBASE
    dta $48 ; --
    dta $48 ; CHBASE
    dta $48 ; WSYNC
    dta $48 ; VCOUNT
    dta $48 ; PENH
    dta $48 ; PENV
    dta $0 ; NMIEN
gtia
    dta $00 ; HPOSP0
    dta $00 ; HPOSP1
    dta $20 ; HPOSP2
    dta $C0 ; HPOSP3
    dta $40 ; HPOSM0
    dta $BF ; HPOSM1
    dta $00 ; HPOSM2
    dta $00 ; HPOSM3
    dta $1 ; SIZEP0
    dta $0 ; SIZEP1
    dta $3 ; SIZEP2
    dta $3 ; SIZEP3
    dta $0 ; SIZEM
    dta $0 ; GRAFP0
    dta $0 ; GRAFP1
    dta $0 ; GRAFP2
    dta $0 ; GRAFP3
    dta $0 ; GRAFM
    dta $88 ; COLPM0
    dta $88 ; COLPM1
    dta $44 ; COLPM2
    dta $44 ; COLPM3
    dta $44 ; COLPF0
    dta $88 ; COLPF1
    dta $2A ; COLPF2
    dta $26 ; COLPF3
    dta $0 ; COLBAK
    dta $24 ; PRIOR
    dta $0 ; VDELAY
    dta $3 ; GRACTL
    dta $0 ; HITCLR
intromusic
    :16 dta $70,$71,$72,$73,$74,$73,$72,$71

    els
    org font
    ins 'mem.bin'
    eif

    org $1000
freqtable2
    :4 dta $8D,$97,$A1,$AB
freqtable
    dta $70,$71,$72,$73,$74,$73,$72,$71
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
    mwa #0 tick
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

;    inc vfine
;    lda vfine
;    cmp #16
;    bne scrolldone
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

;scrolldone
;    mva vfine VSCROL

    ;mwa #dlist DLISTL

    lda tick
    and #15
    tax
    mva freqtable3,x AUDF1
    mva pf2table,x COLPF2
    inc tick

    pla:tax
    pla:tay
    pla
    rti
    rti
    run main
