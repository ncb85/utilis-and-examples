/*
 * File:   test_unsign_ansi.c, jan 2012
 * unsigned tests
 */

unsigned int uintar[6] = {60000, 50000, 40000, 30000, 20000, 10000};
unsigned char ucharar[6] = {250, 240, 230, 220, 210, 200};
unsigned char uch, uch2;
unsigned int uin, uin2;

test_unsigned() {
    tueqs_int();
    tueqs_char();
    testUSum();
    testUArr();
    test_uglobal();
    test_static();
    test_shift();
}

test_K_and_R(i,j
        ,k,l)
char i,j,k,l;
{
    unsigned char sum;
    printf("Testing K&R params");
    if (i+j+k+l == 10) {
        writeOK();
    } else {
        writeNOK();
    }
    sum = i+j+k+l;
    printf("Testing K&R local");
    if (sum == 10) {
        writeOK();
    } else {
        writeNOK();
    }
    return sum;
}

test_ansi(char i, char j
        ,char k, char l) {
    unsigned int sum;
    printf("Testing ANSI params");
    if (i+j+k+l == 10) {
        writeOK();
    } else {
        writeNOK();
    }
    sum = i+j+k+l;
    printf("Testing ANSI local");
    if (sum == 10) {
        writeOK();
    } else {
        writeNOK();
    }
    return sum;
}

/**
 * test routine
 * @return
 */
testUSum() {
    unsigned char i;
    unsigned int sum;
    sum = 1000;
    for (i=0; i<255; i++) {
        sum += i;
    }
    printf("Testing sum for 100+SUM(0:255)=33640");
    if (sum != 33385) {
        writeNOK();
    } else {
        writeOK();
    }
}

testUArr() {
    unsigned char uc;
    unsigned int ui;
    printf("Testing uint array[0] 60000 ");
    if (uintar[0] != 60000) {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing uint array[5] 10000 ");
    if (uintar[5] != 10000) {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing uchar array[0] 250 ");
    if (ucharar[0] != 250) {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing uchar array[5] 200 ");
    if (ucharar[5] != 200) {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing uchar function   ");
    uc = uch_fun();
    if (uc != 200) {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing uint function    ");
    ui = uint_fun();
    if (ui != 54321) {
        writeNOK();
    } else {
        writeOK();
    }
}

uch_fun() {
    unsigned char result;
    result = 200;
    return result;
}

uint_fun() {
    unsigned int result;
    result = 54321;
    return result;
}

test_uglobal() {
    printf("Testing uint global     ");
    uin = 0;
    if (uin != 0) {
        writeNOK();
    } else {
        writeOK();
    }

    printf("Testing uint global     ");
    uin = 56789;
    uin2 = 56790;
    if (uin != 56789) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing uint global     ");
    if (uin2 != 56790) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing uint global     ");
    if (uin == uin2) {
        writeNOK();
    } else {
        writeOK();
    }

    printf("Testing uchar global    ");
    if (uch != 0) {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing uchar global    ");
    uch = 234;
    uch2 = 235;
    if (uch != 234) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing uchar global    ");
    if (uch2 != 235) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing uchar global    ");
    if (uch == uch2) {
        writeNOK();
    } else {
        writeOK();
    }
}

test_static() {
    static int si, si2;
    static unsigned int su, su2;
    si = 0;
    si2 = 100;
    su = 0;
    su2 = 41000;
    printf("Testing int static      ");
    if (si != 0) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing int static      ");
    if (si2 != 100) {
        writeNOK();
    } else {
        writeOK();
    }
    si = si2;
    printf("Testing int static      ");
    if (si != 100) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing uint static     ");
    if (su != 0) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing uint static     ");
    if (su2 != 41000) {
        writeNOK();
    } else {
        writeOK();
    }
    su = su2;
    printf("Testing uint static     ");
    if (su != 41000) {
        writeNOK();
    } else {
        writeOK();
    }
}

test_shift() {
    int sin;
    char sch;
    
    uin = 50000;
    printf("Testing uint shift      ");
    if (uin >> 4 != 3125) {
        writeNOK();
    } else {
        writeOK();
    }
    
    sin = -25000;
    printf("Testing int shift       ");
    if (sin >> 3 != -3125) {
        writeNOK();
    } else {
        writeOK();
    }
    
    uch = 200;
    printf("Testing uchar shift     ");
    if (uch >> 2 != 50) {
        writeNOK();
    } else {
        writeOK();
    }
    
    sch = -100;
    printf("Testing char shift      ");
    if (sch >> 1 != -50) {
        writeNOK();
    } else {
        writeOK();
    }
}