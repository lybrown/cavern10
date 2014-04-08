#!/usr/bin/perl

#.writemem font.bin $3400 $400
#.writemem pm.bin $3b00 $500
#.writemem scr.bin $2000 $d00
#.writemem rows.bin $2d00 $300
#.writemem rows2.bin $3800 $300

sub bin {
    my ($file) = @_;
    open my $fh, $file or die "ERROR: Cannot open $file: $!\n";
    binmode $fh;
    read $fh, my $bin, 9999999;
    return $bin;
}

sub main {
    my ($rowsf, $rows2f, $scrf, $fontf) = @_;

    my $rows = bin($rowsf) . bin($rows2f);
    my $scr = bin($scrf);
    my $font = bin($fontf);

    my @rows = unpack "v*", $rows;
    splice @rows, 0x200, 0x400;
    my $img;
    for my $row (@rows) {
        $img .= substr $scr, ($row - 0x2000), 32;
    }

    my %charmap;
    my $slot = 0x7F;
    my $optfont = pack "C1024";
    for (my $i = 0; $i < length $img; ++$i) {
        my $char = substr $img, $i, 1;
        #warn "CHAR: $char\n";
        my $lo = ord($char) & 0x7F;
        my $hi = ord($char) & 0x80;
        #warn "LOW: $lo\n";
        if (not defined $charmap{$lo}) {
            substr $img, $i, 1, chr($hi | ($charmap{$lo} = $slot));
            substr $optfont, $slot*8, 8, substr $font, $lo*8, 8;
            --$slot;
        }
    }

    print $optfont, $img;
}

main(@ARGV);
