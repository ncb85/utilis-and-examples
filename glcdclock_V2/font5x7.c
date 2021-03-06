/**
 * font.c
 * Tablica czcionek 5x7
 */

char font5x7[] = {
0x00, 0x00, 0x00, 0x00, 0x00,// (spacja)
0x00, 0x00, 0x5F, 0x00, 0x00,// !
0x00, 0x07, 0x00, 0x07, 0x00,// "
0x14, 0x7F, 0x14, 0x7F, 0x14,// #
0x24, 0x2A, 0x7F, 0x2A, 0x12,// $
0x23, 0x13, 0x08, 0x64, 0x62,// %
0x36, 0x49, 0x55, 0x22, 0x50,// &
0x00, 0x05, 0x03, 0x00, 0x00,// '
0x00, 0x1C, 0x22, 0x41, 0x00,// (
0x00, 0x41, 0x22, 0x1C, 0x00,// )
0x08, 0x2A, 0x1C, 0x2A, 0x08,// *
0x08, 0x08, 0x3E, 0x08, 0x08,// +
0x00, 0x50, 0x30, 0x00, 0x00,// ,
0x08, 0x08, 0x08, 0x08, 0x08,// -
0x00, 0x30, 0x30, 0x00, 0x00,// .
0x20, 0x10, 0x08, 0x04, 0x02,// /
0x3E, 0x51, 0x49, 0x45, 0x3E,// 0
0x00, 0x42, 0x7F, 0x40, 0x00,// 1
0x42, 0x61, 0x51, 0x49, 0x46,// 2
0x21, 0x41, 0x45, 0x4B, 0x31,// 3
0x18, 0x14, 0x12, 0x7F, 0x10,// 4
0x27, 0x45, 0x45, 0x45, 0x39,// 5
0x3C, 0x4A, 0x49, 0x49, 0x30,// 6
0x01, 0x71, 0x09, 0x05, 0x03,// 7
0x36, 0x49, 0x49, 0x49, 0x36,// 8
0x06, 0x49, 0x49, 0x29, 0x1E,// 9
0x00, 0x36, 0x36, 0x00, 0x00,// :
0x00, 0x56, 0x36, 0x00, 0x00,// ;
0x00, 0x08, 0x14, 0x22, 0x41,// <
0x14, 0x14, 0x14, 0x14, 0x14,// =
0x41, 0x22, 0x14, 0x08, 0x00,// >
0x02, 0x01, 0x51, 0x09, 0x06,// ?
0x32, 0x49, 0x79, 0x41, 0x3E,// @
0x7E, 0x11, 0x11, 0x11, 0x7E,// A
0x7F, 0x49, 0x49, 0x49, 0x36,// B
0x3E, 0x41, 0x41, 0x41, 0x22,// C
0x7F, 0x41, 0x41, 0x22, 0x1C,// D
0x7F, 0x49, 0x49, 0x49, 0x41,// E
0x7F, 0x09, 0x09, 0x01, 0x01,// F
0x3E, 0x41, 0x41, 0x51, 0x32,// G
0x7F, 0x08, 0x08, 0x08, 0x7F,// H
0x00, 0x41, 0x7F, 0x41, 0x00,// I
0x20, 0x40, 0x41, 0x3F, 0x01,// J
0x7F, 0x08, 0x14, 0x22, 0x41,// K
0x7F, 0x40, 0x40, 0x40, 0x40,// L
0x7F, 0x02, 0x04, 0x02, 0x7F,// M
0x7F, 0x04, 0x08, 0x10, 0x7F,// N
0x3E, 0x41, 0x41, 0x41, 0x3E,// O
0x7F, 0x09, 0x09, 0x09, 0x06,// P
0x3E, 0x41, 0x51, 0x21, 0x5E,// Q
0x7F, 0x09, 0x19, 0x29, 0x46,// R
0x46, 0x49, 0x49, 0x49, 0x31,// S
0x01, 0x01, 0x7F, 0x01, 0x01,// T
0x3F, 0x40, 0x40, 0x40, 0x3F,// U
0x1F, 0x20, 0x40, 0x20, 0x1F,// V
0x7F, 0x20, 0x18, 0x20, 0x7F,// W
0x63, 0x14, 0x08, 0x14, 0x63,// X
0x03, 0x04, 0x78, 0x04, 0x03,// Y
0x61, 0x51, 0x49, 0x45, 0x43,// Z
0x00, 0x00, 0x7F, 0x41, 0x41,// [
0x02, 0x04, 0x08, 0x10, 0x20,// "\"
0x41, 0x41, 0x7F, 0x00, 0x00,// ]
0x04, 0x02, 0x01, 0x02, 0x04,// ^
0x40, 0x40, 0x40, 0x40, 0x40,// _
0x00, 0x01, 0x02, 0x04, 0x00,// `
0x20, 0x54, 0x54, 0x54, 0x78,// a
0x7F, 0x48, 0x44, 0x44, 0x38,// b
0x38, 0x44, 0x44, 0x44, 0x20,// c
0x38, 0x44, 0x44, 0x48, 0x7F,// d
0x38, 0x54, 0x54, 0x54, 0x18,// e
0x08, 0x7E, 0x09, 0x01, 0x02,// f
0x08, 0x14, 0x54, 0x54, 0x3C,// g
0x7F, 0x08, 0x04, 0x04, 0x78,// h
0x00, 0x44, 0x7D, 0x40, 0x00,// i
0x20, 0x40, 0x44, 0x3D, 0x00,// j
0x00, 0x7F, 0x10, 0x28, 0x44,// k
0x00, 0x41, 0x7F, 0x40, 0x00,// l
0x7C, 0x04, 0x18, 0x04, 0x78,// m
0x7C, 0x08, 0x04, 0x04, 0x78,// n
0x38, 0x44, 0x44, 0x44, 0x38,// o
0x7C, 0x14, 0x14, 0x14, 0x08,// p
0x08, 0x14, 0x14, 0x18, 0x7C,// q
0x7C, 0x08, 0x04, 0x04, 0x08,// r
0x48, 0x54, 0x54, 0x54, 0x20,// s
0x04, 0x3F, 0x44, 0x40, 0x20,// t
0x3C, 0x40, 0x40, 0x20, 0x7C,// u
0x1C, 0x20, 0x40, 0x20, 0x1C,// v
0x3C, 0x40, 0x30, 0x40, 0x3C,// w
0x44, 0x28, 0x10, 0x28, 0x44,// x
0x0C, 0x50, 0x50, 0x50, 0x3C,// y
0x44, 0x64, 0x54, 0x4C, 0x44,// z
0x00, 0x08, 0x36, 0x41, 0x00,// {
0x00, 0x00, 0x7F, 0x00, 0x00,// |
0x00, 0x41, 0x36, 0x08, 0x00,// }
0x08, 0x08, 0x2A, 0x1C, 0x08,// ->
0x08, 0x1C, 0x2A, 0x08, 0x08,// <-
0x08, 0x08, 0x3E, 0x1C, 0x08,// -> plna
0x08, 0x1C, 0x3E, 0x08, 0x08,// <- plna
0x38, 0x55, 0x56, 0x55, 0x08,// 'e hacek'
0x48, 0x55, 0x56, 0x55, 0x24,// 's hacek'
0x38, 0x45, 0x46, 0x45, 0x28,// 'c hacek'
0x7C, 0x09, 0x06, 0x05, 0x08,// 'r hacek'
0x44, 0x65, 0x56, 0x4D, 0x44,// 'z hacek'
0x0C, 0x50, 0x52, 0x51, 0x3C,// 'y carka'
0x20, 0x54, 0x56, 0x55, 0x78,// 'a carka'
0x00, 0x44, 0x7E, 0x41, 0x00,// 'i carka'
0x38, 0x54, 0x56, 0x55, 0x08,// 'e carka'
0x3C, 0x40, 0x42, 0x21, 0x7C,// 'u carka'
0x3C, 0x40, 0x43, 0x23, 0x7C,// 'u krouzek'
0x7C, 0x09, 0x06, 0x05, 0x78,// 'n hacek'
0x04, 0x3F, 0x44, 0x40, 0x23,// 't hacek'
0x38, 0x44, 0x48, 0x7F, 0x03,// 'd hacek'
0x38, 0x44, 0x46, 0x45, 0x38,// 'o carka'
0x00, 0x07, 0x05, 0x07, 0x00,// 'stupen'
0x7F, 0x7F, 0x7F, 0x7F, 0x7F,// 'kurzor 1'
0x80, 0x80, 0x80, 0x80, 0x80,// 'kurzor 2'
0x7F, 0x3E, 0x1C, 0x08, 0x00,// Fast Forward
0x00, 0x08, 0x1C, 0x3E, 0x7F,// Fast Backward
0x00, 0x3E, 0x1C, 0x08, 0x00,// Fast Forward small
0x00, 0x08, 0x1C, 0x3E, 0x00,// Fast Backward small
0x04, 0x06, 0x7F, 0x06, 0x04,// sipka nahor
0x10, 0x30, 0x7F, 0x30, 0x10,// sipka nadol
};
/*
	db	00001000b	;147 - 'velke fi'
	db	01010101b
	db	01111111b
	db	01010101b
	db	00001000b

	db	00001110b	;149 - 'male fi'
	db	00010000b
	db	01111100b
	db	00010010b
	db	00001100b

	db	00111000b	;150 - 'alfa'
	db	01000100b
	db	01001000b
	db	00110000b
	db	01001111b

	db	01111110b	;151 - 'beta'
	db	00101010b
	db	00101010b
	db	00101010b
	db	00010100b

	db	01111100b	;152 - 'mikro'
	db	00100000b
	db	00100000b
	db	00011100b
	db	00000000b

	db	00101000b	;153 - 'epsilon'
	db	01010100b
	db	01010100b
	db	01000100b
	db	00000000b

	db	01011000b	;154 - 'omega'
	db	01100100b
	db	00000100b
	db	01100100b
	db	01011000b

	db	01000100b	;155 - 'pi'
	db	00111100b
	db	00000100b
	db	01111100b
	db	01000100b

	db	00100000b	;157 - 'odmocnina'
	db	01000000b
	db	00111110b
	db	00000010b
	db	00000010b

	db	00001000b	;158 - 'neco'
	db	00001000b
	db	00101010b
	db	00001000b
	db	00001000b

	db	00001000b	;159 - 'nekonecno'
	db	00010100b
	db	00001000b
	db	00010100b
	db	00001000b

	db	00000000b	;160 - 'baterka 1'
	db	01111110b
	db	01000011b
	db	01000011b
	db	01111110b

	db	00000000b	;161 - 'baterka 2'
	db	01111110b
	db	01100011b
	db	01100011b
	db	01111110b

	db	00000000b	;162 - 'baterka 3'
	db	01111110b
	db	01110011b
	db	01110011b
	db	01111110b

	db	00000000b	;163 - 'baterka 4'
	db	01111110b
	db	01111011b
	db	01111011b
	db	01111110b

	db	00000000b	;164 - 'baterka 5'
	db	01111110b
	db	01111111b
	db	01111111b
	db	01111110b

	db	01110000b	;165 - 'blesk'
	db	01100100b
	db	01010110b
	db	00001101b
	db	00000100b
*/

