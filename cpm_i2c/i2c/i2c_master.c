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
 * @param addr I2C bus device address
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
 * send data of len from buffer to I2C slave at addr, begins with send of two
 * bytes which are internal device address, e.g. EEPROM AT24C128
 * @param addr I2C bus device address
 * @param buffer*
 * @param len
 * @return success/error code in HL
 */
i2c_send_buffer_with_addr(unsigned int internal_addr, unsigned char addr,
                          char* buffer, unsigned char len) {
#ifdef smallc
#asm
                call get_c_params           ; get params addr, buffer, len
                push h                      ; backup HL - the buffer param
                ldsi 10                     ; DE points to internal_addr
                lhlx                        ; load HL from DE address
                xchg                        ; move to DE
                pop h                       ; restore HL - the buffer param
                call send_buf_addr          ; execute
                ret
#endasm
#endif
}

/**
 * receive data of len to buffer from I2C slave at addr
 * @param addr I2C bus device address
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
                ldsi 6                      ; DE points to buffer
                lhlx                        ; load HL from DE address
                push h                      ; store it
                ldsi 6                      ; DE points to length (last param  on stack)
                lhlx                        ; load HL from DE address
                push h                      ; store it
                ldsi 12                     ; DE points to I2C address (first param)
                ldax d                      ; get I2C address to A
                pop b                       ; get length to C
                pop h                       ; get buffer to HL
                ret
#endasm
#endif
}