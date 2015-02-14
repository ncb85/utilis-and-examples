/*
 * File:   main.c, march 2013
 * command line arguments testing on CP/M
 */


/**
 * main routine
 * @return
 */
main(int argc, int argv[]) {
    int i;
    print("Argument test\n");
    
    for (i=1; i < argc; i++) {
        print("arg:");
        putchar('0' + i);
        print(", value:");
        print(argv[i]);
        print("\n");
    }
}

print(char *str) {
    while (*str) {
        putchar(*str++);
    }
}