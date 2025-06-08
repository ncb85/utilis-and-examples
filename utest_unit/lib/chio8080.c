#define EOL 10
#define CR 13

getchar() {
    return (bdos(1, 1));
}

putchar(char c) {
    if (c == EOL) {
        bdos(2, CR);
    }
    bdos(2, c);
    return c;
}

