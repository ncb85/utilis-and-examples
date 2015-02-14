/**
 * Small-c Comparison Test Program
 *
 * This program tests the various comparison operations
 * performed by the Small-c language.
 */

teqs() {
    /* First test all possible combinations of ==
       for signed integers. */
    printf("Testing == for 0:0");
    if (0 == 0) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing == for 1:1");
    if (1 == 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing == for -1:-1");
    if (-1 == -1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing == for 1:-1");
    if (1 == -1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing == for -1:1");
    if (-1 == 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing == for 0:1");
    if (0 == 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing == for 0:-1");
    if (0 == -1) {
        writeNOK();
    } else {
        writeOK();
    }
}

tnes() {
    /* First test all possible combinations of !=
       for signed integers. */
    printf("Testing != for 0:0");
    if (0 != 0) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing != for 1:1");
    if (1 != 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing != for -1:-1");
    if (-1 != -1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing != for 1:-1");
    if (1 != -1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing != for -1:1");
    if (-1 != 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing != for 0:1");
    if (0 != 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing != for 0:-1");
    if (0 != -1) {
        writeOK();
    } else {
        writeNOK();
    }
}

tges() {
    /* First test all possible combinations of >=
       for signed integers. */
    printf("Testing >= for 0:0");
    if (0 >= 0) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing >= for 1:1");
    if (1 >= 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing >= for -1:-1");
    if (-1 >= -1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing >= for 1:-1");
    if (1 >= -1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing >= for -1:1");
    if (-1 >= 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing >= for 0:1");
    if (0 >= 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing >= for 0:-1");
    if (0 >= -1) {
        writeOK();
    } else {
        writeNOK();
    }
}

tles() {
    /* First test all possible combinations of <=
       for signed integers. */
    printf("Testing <= for 0:0");
    if (0 <= 0) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing <= for 1:1");
    if (1 <= 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing <= for -1:-1");
    if (-1 <= -1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing <= for 1:-1");
    if (1 <= -1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing <= for -1:1");
    if (-1 <= 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing <= for 0:1");
    if (0 <= 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing <= for 0:-1");
    if (0 <= -1) {
        writeNOK();
    } else {
        writeOK();
    }
}

tgts() {
    /* First test all possible combinations of >
       for signed integers. */
    printf("Testing > for 0:0");
    if (0 > 0) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing > for 1:1");
    if (1 > 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing > for -1:-1");
    if (-1 > -1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing > for 1:-1");
    if (1 > -1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing > for -1:1");
    if (-1 > 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing > for 0:1");
    if (0 > 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing > for 0:-1");
    if (0 > -1) {
        writeOK();
    } else {
        writeNOK();
    }
}

tlts() {
    /* First test all possible combinations of <
       for signed integers. */
    printf("Testing < for 0:0");
    if (0 < 0) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing < for 1:1");
    if (1 < 1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing < for -1:-1");
    if (-1 < -1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing < for 1:-1");
    if (1 < -1) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing < for -1:1");
    if (-1 < 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing < for 0:1");
    if (0 < 1) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("Testing < for 0:-1");
    if (0 < -1) {
        writeNOK();
    } else {
        writeOK();
    }
}


tueqs_int() {
    /* First test all possible combinations of <
       for unsigned integers. */
    unsigned int a, b, c;
    a = 40000;
    b = 40000;
    printf("Testing < for 40000:40000");
    if (a < b) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing == for 40000:40000");
    if (a == b) {
        writeOK();
    } else {
        writeNOK();
    }
    b = 60000;
    printf("Testing < for 40000:60000");
    if (a < b) {
        writeOK();
    } else {
        writeNOK();
    }
    a = 4000;
    printf("Testing < for 4000:60000");
    if (a < b) {
        writeOK();
    } else {
        writeNOK();
    }
    a = 60000;
    b = 40000;
    printf("Testing > for 60000:40000");
    if (a > b) {
        writeOK();
    } else {
        writeNOK();
    }
    b = 4000;
    printf("Testing > for 60000:4000");
    if (a > b) {
        writeOK();
    } else {
        writeNOK();
    }
    c = a / b;
    printf("Testing / for 60000:4000");
    if (c == 15) {
        writeOK();
    } else {
        writeNOK();
    }
    a = 250;
    b = 200;
    c = a * b;
    printf("Testing * for 250:200   ");
    if (c == 50000) {
        writeOK();
    } else {
        writeNOK();
    }
    c = a * 200;
    printf("Testing * for 250:const 200");
    if (c == 50000) {
        writeOK();
    } else {
        writeNOK();
    }
}

tueqs_char() {
    /* First test all possible combinations of <
       for unsigned integers. */
    unsigned char a, b, c;
    a = 240;
    b = 240;
    printf("Testing < for 240:244   ");
    if (a < b) {
        writeNOK();
    } else {
        writeOK();
    }
    printf("Testing == for 240:240   ");
    if (a == b) {
        writeOK();
    } else {
        writeNOK();
    }
    b = 250;
    printf("Testing < for 240:250    ");
    if (a < b) {
        writeOK();
    } else {
        writeNOK();
    }
    a = 40;
    printf("Testing < for 40:250     ");
    if (a < b) {
        writeOK();
    } else {
        writeNOK();
    }
    a = 255;
    b = 200;
    printf("Testing > for 255:200    ");
    if (a > b) {
        writeOK();
    } else {
        writeNOK();
    }
    b = 40;
    printf("Testing > for 255:40    ");
    if (a > b) {
        writeOK();
    } else {
        writeNOK();
    }
    c = a / b;
    printf("Testing / for 255:40    ");
    if (c == 6) {
        writeOK();
    } else {
        writeNOK();
    }
    a = 25;
    b = 10;
    c = a * b;
    printf("Testing * for 25:20     ");
    if (c == 250) {
        writeOK();
    } else {
        writeNOK();
    }
    c = a * 10;
    printf("Testing * for 25:const 20");
    if (c == 250) {
        writeOK();
    } else {
        writeNOK();
    }
}