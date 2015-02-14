
#include <stdio.h>

/*
** sscanf(buffer, ctlstring, arg, arg, ...) - Formatted read.
** Operates as described by Kernighan & Ritchie.
** b, c, d, o, s, u, and x specifications are supported.
** Note: b (binary) is a non-standard extension.
*/
sscanf(argc) int argc; {
  int *nxtarg;
  char *carg, *ctl, *ptr;
  unsigned u;
  int  *narg, wast, ac, width, ch, cnv, base, ovfl, sign;
  ac = 0;
  nxtarg = &argc - CCARGC() + 1;
  ptr = *nxtarg++;
  ctl = *nxtarg++;
  while(*ctl) {
    if(isspace(*ctl)) {++ctl; continue;}
    if(*ctl++ != '%') continue;
    if(*ctl == '*') {narg = carg = &wast; ++ctl;}
    else             narg = carg = *nxtarg++;
    ctl += utoi(ctl, &width);
    if(!width) width = 32767;
    if(!(cnv = *ctl++)) break;
    while(isspace(ch = *ptr++)) ;
    if(ch == 0) {if(ac) break; else return(EOF);}
    --ptr;;
    switch(cnv) {
      case 'c':
        *carg = *ptr++;
        break;
      case 's':
        while(width--) {
          if((*carg = *ptr++) == 0) break;
          if(isspace(*carg)) break;
          if(carg != &wast) ++carg;
          }
        *carg = 0;
        break;
      default:
        switch(cnv) {
          case 'b': base =  2; sign = 1; ovfl = 32767; break;
          case 'd': base = 10; sign = 0; ovfl =  3276; break;
          case 'o': base =  8; sign = 1; ovfl =  8191; break;
          case 'u': base = 10; sign = 1; ovfl =  6553; break;
          case 'x': base = 16; sign = 1; ovfl =  4095; break;
          default:  return (ac);
          }
        *narg = u = 0;
        while(width-- && !isspace(ch=*ptr++) && ch!=0) {
          if(!sign)
            if(ch == '-') {sign = -1; continue;}
            else sign = 1;
          if(ch < '0') return (ac);
          if(ch >= 'a')      ch -= 87;
          else if(ch >= 'A') ch -= 55;
          else               ch -= '0';
          if(ch >= base || u > ovfl) return (ac);
          u = u * base + ch;
          }
        *narg = sign * u;
      }
    ++ac;                          
    }
  return (ac);
  }


