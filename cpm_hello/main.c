/*
 * File:   main.c, march 2013
 * hello world on CP/M
 */


/**
 * main routine
 * @return
 */
main() {
    print("Hello World!!");
}

/**
 * prints zero terminated string
 * @param str
 * @return 
 */
print(char *str) {
    while (*str) {
        putchar(*str++);
    }
}