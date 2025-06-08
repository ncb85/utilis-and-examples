        ; C run-time start-off procedure, CRTSO for Small C.
        .module CRTSO
        .area   CRTSO   (REL,CON,CSEG)   ;program area CRTSO is ABSOLUTE at 0x0100
        .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
        .nlist  (pag)

        .globl  main

TRAP_ROUTINNE   .equ    0xFFF2  ; interrupt vector - 3 bytes (C3 XXXX)
RST55_ROUTINNE  .equ    0xFFEF  ; interrupt vector - 3 bytes (C3 XXXX)
RST65_ROUTINNE  .equ    0xFFEC  ; interrupt vector - 3 bytes (C3 XXXX)
RST75_ROUTINNE  .equ    0xFFE9  ; interrupt vector - 3 bytes (C3 XXXX)
STATUS_CMD_REG_8155 .equ 0x00   ; i/o address of 8155

init:
        di                      ; disable all interrupts
        lxi     sp,0xFFE0       ; set stack pointer

        jmp     main            ; call main program
crtsoend::
       .end
