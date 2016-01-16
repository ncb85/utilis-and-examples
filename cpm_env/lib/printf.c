/**
        PRINTF Library Documentation
 
PRINTF supplies formatted output like that described by
Kernighan and Ritchie.  The input conversion routine utoi (for
unsigned integers) is also supplied.   
 
FUNCTIONS
 
printf(controlstring, arg, arg, ...) -- formatted print 
    "controlstring" is a string which can contain any of
    the following format codes: 

        %d	decimal integer 
        %u	unsigned decimal integer 
        %x	hexidecimal integer 
        %c	ASCII character 
        %s	null-terminated ASCII string 
        %f	fixed point conversion for double
        %e	floating point conversion for double 

    For each format code, there is an "arg" - a pointer to
    an object of that type. Between the '%' and the format
    code letter field specification may appear. For formats
    'f' and 'e', the specification consists of two integers
    separated by a period. The first specifies the minimum
    field width, and the second the number of digits to be
    printed after the decimal point. For all other formats,
    the specification consists only of the one integer
    giving the minimum field width. If there is no field 
    specification, the item is printed in no more space 
    than is necessary. 

        Example			  Output 

    printf(" decimal: %d ",15+2)	  decimal: 17  
    printf(" unsigned: %u ",-1)	  unsigned: 65535  
    printf(" hexidecimal: %x ",-1)	  hexidecimal: FFFF  
    printf(" string: %s ","hello")	  string: hello  
    printf(" character: %c ",65)	  character: A  
    printf(" fixed: %f ",1./7.)	  fixed: .142857  
    printf(" exponent: %8.5e ",1./7.) exponent: 1.42857e-1

    printf returns the number of characters output.
 
fprintf(unit, controlstring, arg, arg, ..)
    Provides functions similar to printf, but with output
    going to the file associated with 'unit'.
    fprintf returns the number of characters output.

sprintf(string, controlstring, arg, arg, ..)
    Provides functions similar to printf, but with output
    going to the character pointer 'string'.
    sprintf returns the number of characters output.

itod(n, str, sz)  int n;  char str[];  int sz;  
    convert n to signed decimal string of width sz, 
    right adjusted, blank filled; returns str 
    if sz > 0 terminate with null byte 
    if sz = 0 find end of string 
    if sz < 0 use last byte for data 
  
itou(nbr, str, sz)  int nbr;  char str[];  int sz;  
    convert nbr to unsigned decimal string of width sz, 
    right adjusted, blank filled; returns str 
    if sz > 0 terminate with null byte 
    if sz = 0 find end of string 
    if sz < 0 use last byte for data 
  
itox(n, str, sz)  int n;  char str[];  int sz;  
    converts n to hex string of length sz, right adjusted 
    and blank filled, returns str 
    if sz > 0 terminate with null byte 
    if sz = 0 find end of string 
    if sz < 0 use last byte for data 
  
ftoa(x,f,str) double x; int f; char *str; 
    converts x to fixed point string with f digits after 
    the decimal point, return str 
  
ftoe(x,f,str) double x; int f; char *str; 
    converts x to floating point string with f digits after
    the decimal point, return str 
 
utoi(decstr, nbr)  char *decstr;  int *nbr;  
    converts unsigned decimal ASCII string to integer 
    number. Returns field size, else ERR on error. (This is
    used to interpret the specification fields.) 
 
 
AUTHOR
    J. E. Hendrix for the original routines. J. R.
    Van Zandt for ftoa, ftoe, and the floating point
    modifications in printf.
 
 
INTERNAL DOCUMENTATION 
 
    The method used in ftoa to convert to a decimal string
involves more divisions than the classical method, but does not
require that the original number be scaled down at the
beginning. It was found that this initial scaling was causing
loss of precision. The present algorithm should always convert
an integer exactly if it can be represented exactly as a
floating point number (that is, if it is less than 2**40).

The routines seen by the user (printf, fprintf, sprintf) are in
the library PRINTF.  The routine which does all the hard work,
_printf, is in either PRINTF1 or PRINTF2 depending on whether or
not floating point output is required.
 */

#include <stdio.h>

int ccargc;
char *buffer, *_string;

/**
 * fprintf(fd, ctlstring, arg, arg, ...) - Formatted print.
 * Operates as described by Kernighan & Ritchie.
 * b, c, d, o, s, u, and x specifications are supported.
 * Note: b (binary) is a non-standard extension.
 */
fprintf(int argc) {
    int *nxtarg;
    #asm
        sta     ccargc
        xra     a
        sta     ccargc+1
    #endasm
    nxtarg = ccargc + &argc;
	_string = NULL;
    return _print(*(--nxtarg), --nxtarg);
}

/**
 * printf(ctlstring, arg, arg, ...) - Formatted print.
 * Operates as described by Kernighan & Ritchie.
 * b, c, d, o, s, u, and x specifications are supported.
 * Note: b (binary) is a non-standard extension.
 */
printf(int argc) {
    int *nxtarg;
    #asm
        sta     ccargc
        xra     a
        sta     ccargc+1
    #endasm
    nxtarg = ccargc + &argc - 1;
	_string = NULL;
    return _print(stdout, nxtarg);
}

sprintf(int argc) {
	int *nxtarg;
    #asm
        sta     ccargc
        xra     a
        sta     ccargc+1
    #endasm
    nxtarg = ccargc + &argc;
	_string = *--nxtarg;
	return _print(stdin, --nxtarg);
}

/**
 * _print(fd, ctlstring, arg, arg, ...)
 * Called by fprintf() and printf().
 */
_print(int fd, int *nxtarg) {
    int arg, left, pad, cc, len, maxchr, width;
    char *ctl, *sptr, str[17];
    cc = 0;
    ctl = *nxtarg--;
    while (*ctl) {
        if (*ctl != '%') {
            _outc(*ctl++, fd);
            ++cc;
            continue;
        } else {
            ++ctl;
        }
        if (*ctl == '%') {
            _outc(*ctl++, fd);
            ++cc;
            continue;
        }
        if (*ctl == '-') {
            left = 1;
            ++ctl;
        } else left = 0;
        if (*ctl == '0') pad = '0';
        else pad = ' ';
        if (isdigit(*ctl)) {
            width = atoi(ctl++);
            while (isdigit(*ctl)) ++ctl;
        } else width = 0;
        if (*ctl == '.') {
            maxchr = atoi(++ctl);
            while (isdigit(*ctl)) ++ctl;
        } else maxchr = 0;
        arg = *nxtarg--;
        sptr = str;
        switch (*ctl++) {
            case 'c': str[0] = arg;
                str[1] = NULL;
                break;
            case 's': sptr = arg;
                break;
            case 'd': itoa(arg, str);
                break;
            case 'b': utoab(arg, str, 2);
                break;
            case 'o': utoab(arg, str, 8);
                break;
            case 'u': utoab(arg, str, 10);
                break;
            case 'x': utoab(arg, str, 16);
                break;
            default: return (cc);
        }
        len = strlen(sptr);
        if (maxchr && maxchr < len) {
            len = maxchr;
        }
        if (width > len) {
            width = width - len;
        } else {
            width = 0;
        }
        if (!left) {
            while (width--) {
                _outc(pad, fd);
                ++cc;
            }
        }
        while (len--) {
            _outc(*sptr++, fd);
            ++cc;
        }
        if (left) {
            while (width--) {
                _outc(pad, fd);
                ++cc;
            }
        }
    }
    return (cc);
}

/**
 * _outc - output a single character
 * if _string is not null send output to a string instead
 */
_outc(char c, int fd) {
	if (_string == NULL)
		fputc(c, fd);
	else
		*_string++ = c;
}
