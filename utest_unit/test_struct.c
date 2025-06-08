/*
 * File:   test_struct2.c, jan 2013
 * struct / union tests
 */
#include "print.h"

struct sa {
    unsigned int a;
    unsigned char b;
    int c;
    char d;
};

struct sb {
    unsigned int a;
    int b;
    unsigned char c;
    char d;
};

struct sa struct_a = {5000, 'x', -5000, 'y'};
struct sb struct_b = {34567, -23456, 'a', -123};
struct sb struct_ac[5];

union ua {
    int a;
    char b;
} union_a;

testStructSuite() {
    testStructAEq();
    testStructBEq();
    testStructAssign();
    testUnionAssign();
    testStructLocaleAssign();
    testStructArray();
    testStructLocaleArray();
    testStructPointer();
}

testStructAEq() {
    puts("Testing global struct_a equals");
    if (struct_a.a == 5000) {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing global struct_a equals");
    if (struct_a.b == 'x') {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing global struct_a equals");
    if (struct_a.c == -5000) {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing global struct_a equals");
    if (struct_a.d == 'y') {
        writeOK();
    } else {
        writeNOK();
    }
}

testStructBEq() {
    puts("Testing global struct_b equals");
    if (struct_b.a == 34567) {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing global struct_b equals");
    if (struct_b.b == -23456) {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing global struct_b equals");
    if (struct_b.c == 'a') {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing global struct_b equals");
    if (struct_b.d == -123) {
        writeOK();
    } else {
        writeNOK();
    }
}

testStructAssign() {
    puts("Testing global struct_a assign");
    struct_a.a = struct_b.a;
    if (struct_a.a == 34567) {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing global struct_a assign");
    struct_a.c = struct_b.b;
    if (struct_a.c == -23456) {
        writeOK();
    } else {
        writeNOK();
    }

    puts("Testing global struct_b assign");
    struct_a.c = -4567;
    struct_b.b = struct_a.c;
    if (struct_b.b == -4567) {
        writeOK();
    } else {
        writeNOK();
    }

    puts("Testing global struct_b assign");
    struct_b.c = struct_a.b;
    if (struct_b.c == 'x') {
        writeOK();
    } else {
        writeNOK();
    }
}

testUnionAssign() {
    puts("Testing global union assign");
    union_a.a = 300;
    if (union_a.b == 44) {
        writeOK();
    } else {
        writeNOK();
    }

    puts("Testing global union assign");
    union_a.b = 0;
    if (union_a.a == 256) {
        writeOK();
    } else {
        writeNOK();
    }
}

// TODO locales
testStructLocaleAssign() {
    struct sa struct_al;
    struct_al.a = struct_b.a;
    struct_al.b = struct_b.c;
    struct_al.c = struct_b.b;
    struct_al.d = struct_b.d;
    puts("Testing locale struct_al assign");
    if (struct_al.a == 34567) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing locale struct_al assign");
    struct_b.c = struct_a.b;
    if (struct_al.b == 'x') {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing locale struct_al assign");
    if (struct_al.c == -4567) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing locale struct_al assign");
    if (struct_al.d == -123) {
        writeOK();
    } else {
        writeNOK();
    }
}

testStructArray() {
    struct_ac[0].a = 10000;
    struct_ac[0].b = -23456;
    struct_ac[0].c = 255;
    struct_ac[0].d = 'p';
    
    struct_ac[1].a = 20000;
    struct_ac[1].b = -12345;
    struct_ac[1].c = 128;
    struct_ac[1].d = 'q';
    
    struct_ac[2].a = 30000;
    struct_ac[2].b = -2345;
    struct_ac[2].c = 129;
    struct_ac[2].d = 'r';
    
    struct_ac[3].a = 40000;
    struct_ac[3].b = -345;
    struct_ac[3].c = 130;
    struct_ac[3].d = 's';
    
    struct_ac[4].a = 50000;
    struct_ac[4].b = -45;
    struct_ac[4].c = 131;
    struct_ac[4].d = 't';
    puts("Testing global struct_a array");
    if (struct_ac[0].d == 'p') {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing global struct_a array");
    if (struct_ac[3].b == -345) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing global struct_a array");
    if (struct_ac[1].c == 128) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing global struct_a array");
    if (struct_ac[2].a == 30000) {
        writeOK();
    } else {
        writeNOK();
    }
}

testStructLocaleArray() {
    struct sa struct_ac[5];
    char p;
    
    struct_ac[0].a = 10001;
    struct_ac[0].b = -23456;
    struct_ac[0].c = 255;
    struct_ac[0].d = 'p';
    struct_ac[1].a = 20001;
    struct_ac[1].b = -12345;
    struct_ac[1].c = 128;
    struct_ac[1].d = 'q';
    struct_ac[2].a = 30001;
    struct_ac[2].b = -2345;
    struct_ac[2].c = 129;
    struct_ac[2].d = 'r';
    struct_ac[3].a = 40001;
    struct_ac[3].b = -345;
    struct_ac[3].c = 130;
    struct_ac[3].d = 's';
    struct_ac[4].a = 50001;
    struct_ac[4].b = -45;
    struct_ac[4].c = 131;
    struct_ac[4].d = 't';
    puts("Testing locale struct_ac array");
    if (struct_ac[0].d == 'p') {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing locale struct_ac array");
    if (struct_ac[2].d == 'r') {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing locale struct_ac array");
    if (struct_ac[4].a == 50001) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing locale struct_ac array");
    if (struct_ac[01].c == 128) {
        writeOK();
    } else {
        writeNOK();
    }
    struct_ac[2].d = struct_ac[4].d;
    puts("Testing locale struct_ac array");
    if (struct_ac[2].d == 't') {
        writeOK();
    } else {
        writeNOK();
    }
    struct_ac[4].c = struct_ac[3].c;
    puts("Testing locale struct_ac array");
    if (struct_ac[4].c == 130) {
        writeOK();
    } else {
        writeNOK();
    }
}

testStructPointer() {
    // test struct pointer arithmetics
    struct sa *strap;
    int tmp, tmp2;
    struct_ac[3].b = 98;
    strap = struct_ac;

    puts("Testing struct pointer arithmetics");
    tmp = strap;
    tmp2 = strap + 3;
    if (tmp2 - tmp == 3*6) {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing struct sizeof   ");
    tmp = sizeof(struct_a);
    if (tmp == 6) {
        writeOK();
    } else {
        writeNOK();
    }
    
    puts("Testing struct array sizeof ");
    tmp = sizeof(struct_ac);
    if (tmp == 30) {
        writeOK();
    } else {
        writeNOK();
    }
    
    
    puts("Testing struct pointer  ");
    if ((strap + 3)->b == 98) {
        writeOK();
    } else {
        writeNOK();
    }
}