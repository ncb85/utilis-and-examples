/*
 * Main interface to scanf-type routines, independent of integer/float
 *
 * scanf(controlstring, arg, arg, ...)  or 
 * sscanf(string, controlstring, arg, arg, ...) or
 * fscanf(file, controlstring, arg, arg, ...) --  formatted read
 *        operates as described by Kernighan & Ritchie
 */


#include <stdio.h>
//#include <ctype.h>

#define ERR (-1)


extern int ccargc;
char *_String1;
int _Oldch;

scanf(args)
int args;
{
    #asm
        sta ccargc
        xra a
        sta ccargc + 1
    #endasm
    _String1 = NULL;
    return ( _scanf(stdin, ccargc + &args - 1));
}

fscanf(args)
int args;
{
    int *nxtarg;
    #asm
        sta ccargc
        xra a
        sta ccargc + 1
    #endasm

    _String1 = NULL;
    nxtarg = ccargc + &args;
    return ( _scanf(*(--nxtarg), --nxtarg));
}

sscanf(args)
int args;
{
    int *nxtarg;
    #asm
        sta ccargc
        xra a
        sta ccargc + 1
    #endasm

    nxtarg = ccargc + &args - 1;
    _String1 = *nxtarg;
    return ( _scanf(stdout, --nxtarg));
}

/*
 * _getc - fetch a single character from file
 *         if _String1 is not null fetch from a string instead
 */
_getc(fd)
int fd;
{
    int c;

    if (_Oldch != EOF) {
        c = _Oldch;
        _Oldch = EOF;
        return c;
    } else {
        if (_String1 != NULL) {
            if ((c = *_String1++)) return c;
            else {
                --_String1;
                return EOF;
            }
        } else {
            return fgetc(fd);
        }
    }
}

/*
 * unget character assume only one source of characters
 * i.e. does not require file descriptor
 */
_ungetc(ch)
int ch;
{
    _Oldch = ch;
}
