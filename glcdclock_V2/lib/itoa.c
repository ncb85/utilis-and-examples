#include <stdio.h>

#define EOS 0

/**
 * integer to ascii representation
 * @param n the integer number
 * @param s string buffer
 * @return 
 */
itoa(int n, char s[]) {
    int i, sign;

    if ((sign = n) < 0) {
        n = -n;
    }
    i = 0;
    do {
        s[i++] = n % 10 + '0';
    } while ((n = n / 10) > 0);
    if (sign < 0) {
        s[i++] = '-';
    }
    s[i] = EOS;
    reverse(s);
}

/**
 * unsigned integer to ASCII
 * @param n the unsigned number
 * @param s string buffer
 * @param base
 * @return 
 */
utoab(unsigned int n, char s[], int base) {
    int i, offset;
    i = 0;
    
    do {
        s[i] = n % base;
        if (s[i] < 10 )
			offset = '0' ;
		else
			offset = 55 ; // 'A' - 10
        s[i] = s[i] + offset;
        i++;
    } while ((n = n / base) > 0);
    
    s[i] = EOS;
    reverse(s);
}

