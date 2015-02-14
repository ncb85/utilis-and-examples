/**
 * Small-c reference and dereference Test Program
 *
 * This program tests the & and * operations
 * performed by the Small-c language.
 */

int a, *ap;
char b, *bp;
unsigned int c, *cp;
unsigned char d, *dp;

struct sa {
    unsigned int as;
    unsigned char bs;
    int cs;
    char ds;
};

struct sb {
    unsigned int as;
    int bs;
    unsigned char cs;
    char ds;
};

struct sa struct_as = {5000, 'x', -5000, 'y'}, *sap;
struct sb struct_bs = {34567, -23456, 'a', -123}, *sbp;
struct sb struct_br[5];

test_pointer_suite() {
    struct_br[1].as = 50178;
    
    test_refs();
    test_locale_refs();
    test_str_refs();
    test_locale_str_refs();
}

test_refs() {
    /* First test all possible combinations of pointers. */
    printf("Testing int pointer");
    a = 5555;
    ap = &a;
    if (*ap == 5555) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing char pointer");
    b = -55;
    bp = &b;
    if (*bp == -55) {
        writeOK();
    } else {
        writeNOK();
    }

    printf("Testing uint pointer");
    c = 25555;
    cp = &c;
    if (*cp != 25555) {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing uchar pointer");
    d = 155;
    dp = &d;
    if (*dp == 155) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing int pointer");
    c = 44444;
    ap = &c;
    if (*cp == 44444) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing char pointer");
    d = 155;
    bp = &d;
    if (*bp < 0) { //155 is signed negative number
        writeOK();
    } else {
        writeNOK();
    }
}

test_locale_refs() {
    char pa[2], *pb;
    pb = pa;
    pa[1] = '\0';
    printf("Testing locale char pointer");
    if (*++pb == 0) {
        writeOK();
    } else {
        writeNOK();
    }
    test_param_refs(pa);
}

test_param_refs(char *pa) {
    *pa = '\0';
    printf("Testing param char pointer");
    if (*pa == 0) {
        writeOK();
    } else {
        writeNOK();
    }
}

test_str_refs() {
    /*sbp = &struct_bs;
    printf("Testing struct pointer");
    if (sbp->bs == 34567) {
        writeOK();
    } else {
        writeNOK();
    }*/
}

test_locale_str_refs() {
    struct sb *lpsb;
    lpsb = struct_br;
    ++lpsb;
    printf("Testing local struct pointer");
    if (lpsb->as == 50178) {
        writeOK();
    } else {
        writeNOK();
    }
}

