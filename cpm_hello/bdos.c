bdos (c, de) int c, de; {
#asm
;       CP/M support routine
;       bdos(C,DE);
;       char *DE; int C;
;       returns H=B,L=A per CPM standard
        pop     h       ; hold return address
        pop     d       ; get DE register argument
        pop     b       ; get bdos function number (C reg)
        push    d
        push    b
        push    h
        call    5
        mov     h,b
        mov     l,a
#endasm
}

