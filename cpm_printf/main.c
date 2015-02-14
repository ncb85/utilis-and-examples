/*
 * File:   main.c, march 2013
 * printf test on CP/M
 */
#include <stdio.h>

char buff[80], *txt;
int stkp;

test_fprintf() {
    FILE *output;
    
    if ((output = fopen("out.txt", "w")) == NULL) {
        printf("Open for write failure\n");
        exit(1);
    }

    fprintf(output, "d 1000 -> %d\n", 1000);
    fprintf(output, "016b 100, -16b 100, b 100 -> '%016b', '%-16b', '%b'\n\n", 100, 100, 100);

    fflush(output);
    fclose(output);
}

test_sprintf() {
    sprintf(buff, "d 1000 -> '%d' now x 1000 -> '%x' end", 1000, 1000);
    printf("buff -> %s\n", buff);
    printf("txt -> %s\n", txt);
}

/**
 * main routine
 * @return
 */
main(int argc, int argv[]) {
    printf("Printf test\n");
    txt = "Printf %s test";
    printf("%s\n", txt);
    
    printf("d 1000 -> %d\n", 1000);
    printf("d -9999 -> %d\n", -9999);
    printf("u 1000 -> %u\n", 1000);
    printf("o 55443 -> %o\n", 55443);
    printf("u 55443 -> %u\n", 55443);
    printf("x 55443 -> %x\n", 55443);
    printf("b 55443 -> %b\n", 55443);
    printf("05d 100 -> '%05d'\n", 100);
    printf("-5d 100, -4x 100, 04x 100 -> '%-5d', '%-4x', '%04x'\n", 100, 100, 100);
    printf("016b 100, -16b 100, b 100 -> '%016b', '%-16b', '%b'\n", 100, 100, 100);
    
    test_fprintf();
    test_sprintf();
}
