/**
 * C methods for I2C communication protocol library using Philips PCF8584 bus controller
 * they are merely stubs for driver's routines implemented in pcf8584.asm file
 */

i2c_init_pcf8584() {
#ifdef smallc
#asm
                call pcf8584_init           ; call driver
#endasm
#endif
}

i2c_reset_bus() {
#ifdef smallc
#asm
                call reset_i2c_bus          ; call driver
                ret
#endasm
#endif
}

/**
 * send data of len from buffer to I2C slave at addr
 * @param addr
 * @param buffer*
 * @param len
 * @return success/error code in HL
 */
i2c_send_buffer(unsigned char addr, char* buffer, unsigned char len) {
#ifdef smallc
#asm
                call get_c_params           ; get params
                call send_buf               ; execute
                ret
#endasm
#endif
}

/**
 * receive data of len to buffer from I2C slave at addr
 * @param addr
 * @param buffer*
 * @param len
 * @return success/error code in HL
 */
i2c_recv_buffer(unsigned char addr, char* buffer, unsigned char len) {
#ifdef smallc
#asm
                call get_c_params           ; get params
                xchg                        ; move buffer address to DE
                call recv_buf               ; execute
                ret
get_c_params:   ; get params from stack (as placed by C) and move them to approp.registers
                ldsi 6                      ; DE point to buffer
                lhlx                        ; load HL from DE address
                push h                      ; store it
                ldsi 6                      ; DE point to length (last param  on stack)
                xchg                        ; move to HL
                mov l,m                     ; get length
                push h                      ; store it
                ldsi 12                     ; DE point to I2C address (first param)
                ldax d                      ; get I2C address to A
                pop b                       ; get length to C
                pop h                       ; get buffer to HL
                ret
#endasm
#endif
}