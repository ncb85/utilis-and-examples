;TITLE "BINARY TO BCD CONVERTER"
;BY D. M. BROCKMAN, 11648 MILITARY RD. SO., SEATTLE, WA 98168
;
;THIS SUBROUTINE CONVERTS THE 32-BIT BINARY NUMBER STORED
;  AT 'BIN' TO A 10-DIGIT PACKED BCD NUMBER STORED AT 'BCD.'
;  REGISTERS B, C, H, L, AND A ARE USED.
;
;DEFINE STORAGE FOR NUMBERS:
;
            ORG 200H
BIN:        DS 1 ;LSB BYTE
            DS 2
            DS 1 ;MSB BYTE
                 ;
BCD:        DS 1 ;LS DIGITS
            DS 3
            DS 1 ;MS DIGITS
                 ;
                 ;INITIALIZE THE BCD RESULT BYTES TO ZERO:
                 ;
            ORG 100H
BINBCD:     LXI H,BCD ;POINT AT RESULT
            MVI B,5 ;SET LOOP COUNTER
ILOOP:      MVI M,0 ;STORE A ZERO
            INX H ;POINT TO SEXT BYTE
            DCR B ;DECREMENT LOOP COUNTER
            JNZ ILOOP ;LOOP IF NOT DONE
                ;
                ;INITIALIZE THE BIT COUNTER TO EQUAL THE NUMBER OF
                ;  BINARY BITS TO BE SHIFTED:
                ;
            MVI B,32 ;NUMBER OF BITS TO SHIFT
CLOOP:          ;THE MAIN LOOP POINT
                ;
                ;INITIALIZE FOR A MULTIPLE PRECISION LEFT SHIFT
                ;  OF THE BINARY NUMBER:
                ;
            LXI H,BIN ;POINT AT NUMBER
            MVI C,4 ;NUMBER OF BYTES
            XRA A ;CLEAR THE CARRY
                ;
                ;SHIFT THE BINARY NUMBER ONE PLACE LEFT AND LEAVE THE MSB
                ;  IN THE CARRY:
                ;
RLOOP:      MOV A,M ;GET BYTE
            RAL ;SHIFT LEFT
            MOV M,A ;STORE BYTE
            INX H ;POINT AT NEXT BYTE
            DCR C ;DECREMENT BYTE COUNT
            JNZ RLOOP ;LOOP IF NOT DONE
                ;
                ;INITIALIZE TO DOUBLE THE BCD RESULT REGISTER CONTENTS
                ;  BY PERFORMING A MULTIPLE PRECISION BCD ADD:
                ;
            LXI H,BCD ;POINT AT RESULT
            MVI C,5 ;SETUP BYTE COUNTER
                ;
                ;DOUBLE THE RESULT BCD FASHION, ADDING IN THE CARRY BIT:
                ;
BLOOP:      MOV A,M ;GET BYTE
            ADC M ;ADD IT TO ITSELF
            DAA ;BCD CONVERT
            MOV M,A ;RESTORE
            INX H ;POINT AT NEXT BYTE
            DCR C ;DECREMENT BYTE COUNTER
            JNZ BLOOP ;LOOP IF NOT DONE
                ;
                ;TEST TO SEE IF ALL BITS HAVE BEEN SHIFTED FROM BINARY
                ;  NUMBER TO THE BCD RESULT. IF NOT, RETURN TO MAIN LOOP.
                ;
            DCR B ;DECREMENT BIT COUNTER
            JNZ CLOOP ;LOOP IF NOT DONE
            RET
               
            END