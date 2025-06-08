/* Small-c Comparison Test Program
 *
 * This program tests the various comparison operations
 * performed by the Small-c language.
 */

teqs() {
    /* First test all possible combinations of ==
       for signed integers. */
    puts("Testing == for 0:0");
    if (0 == 0) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing == for 1:1");
    if (1 == 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing == for -1:-1");
    if (-1 == -1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing == for 1:-1");
    if (1 == -1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing == for -1:1");
    if (-1 == 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing == for 0:1");
    if (0 == 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing == for 0:-1");
    if (0 == -1) {
        writeNOK();
    } else {
        writeOK();
    }
}

tnes() {
    /* First test all possible combinations of !=
       for signed integers. */
    puts("Testing != for 0:0");
    if (0 != 0) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing != for 1:1");
    if (1 != 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing != for -1:-1");
    if (-1 != -1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing != for 1:-1");
    if (1 != -1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing != for -1:1");
    if (-1 != 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing != for 0:1");
    if (0 != 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing != for 0:-1");
    if (0 != -1) {
        writeOK();
    } else {
        writeNOK();
    }
}

tges() {
    /* First test all possible combinations of >=
       for signed integers. */
    puts("Testing >= for 0:0");
    if (0 >= 0) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing >= for 1:1");
    if (1 >= 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing >= for -1:-1");
    if (-1 >= -1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing >= for 1:-1");
    if (1 >= -1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing >= for -1:1");
    if (-1 >= 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing >= for 0:1");
    if (0 >= 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing >= for 0:-1");
    if (0 >= -1) {
        writeOK();
    } else {
        writeNOK();
    }
}

tles() {
    /* First test all possible combinations of <=
       for signed integers. */
    puts("Testing <= for 0:0");
    if (0 <= 0) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing <= for 1:1");
    if (1 <= 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing <= for -1:-1");
    if (-1 <= -1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing <= for 1:-1");
    if (1 <= -1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing <= for -1:1");
    if (-1 <= 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing <= for 0:1");
    if (0 <= 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing <= for 0:-1");
    if (0 <= -1) {
        writeNOK();
    } else {
        writeOK();
    }
}

tgts() {
    /* First test all possible combinations of >
       for signed integers. */
    puts("Testing > for 0:0");
    if (0 > 0) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing > for 1:1");
    if (1 > 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing > for -1:-1");
    if (-1 > -1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing > for 1:-1");
    if (1 > -1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing > for -1:1");
    if (-1 > 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing > for 0:1");
    if (0 > 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing > for 0:-1");
    if (0 > -1) {
        writeOK();
    } else {
        writeNOK();
    }
}

tlts() {
    /* First test all possible combinations of <
       for signed integers. */
    puts("Testing < for 0:0");
    if (0 < 0) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing < for 1:1");
    if (1 < 1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing < for -1:-1");
    if (-1 < -1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing < for 1:-1");
    if (1 < -1) {
        writeNOK();
    } else {
        writeOK();
    }
    puts("Testing < for -1:1");
    if (-1 < 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing < for 0:1");
    if (0 < 1) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("Testing < for 0:-1");
    if (0 < -1) {
        writeNOK();
    } else {
        writeOK();
    }
}

