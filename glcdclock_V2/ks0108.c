/**
 * Universal KS0108 driver library
 * (c) Radoslaw Kwiecien, radek@dxp.pl
 */

#define KS0108_SCREEN_WIDTH     128
#define KS0108_SCREEN_HEIGHT    64

#define DISPLAY_SET_X           0x40
#define DISPLAY_SET_Y           0xB8
#define DISPLAY_START_LINE      0xC0
#define DISPLAY_ON_CMD          0x3E
#define ON                      0x01
#define OFF                     0x00
#define DISPLAY_STATUS_BUSY     0x80

/*
 * Po instrukcich zapisu a cteni dat, se automaticky zvysuje hodnota citace adresy v X.
 * Po poslednim sloupci se zacina opet zleva. Stranky se automaticky neinkrementuji.
 * Registr pro posuv prvniho radku lze vyuzit pro vertikalni posouvani obsahu LCD.
 * Vyznam instrukce         RS      R/W     DB7     DB6     DB5     DB4     DB3     DB2     DB1     DB0
 * zap/vyp D=1 - zapnuto    0       0       0       0       1       1       1       1       1       D
 * nastavi stranku pameti
 * (svislou osmici pixelu
 * brano shora), 0-7        0       0       1       0       1       1       1       stranka
 * nastavi pozici X 0-63    0       0       0       1       X adresa
 * nastavi pozici Y 0-63    0       0       1       1       Y posuv
 * zapis dat
 * (LSB nahore, MSB dole)   1       0       data byte
 * cteni dat
 * (LSB nahore, MSB dole)   1       1       data byte
 * cteni stavoveho slova
 * B=1 busy, B=0 ready
 * D=1 - LCD zapnut
 * D=0 - LCD vypnut
 * R=1 - probiha reset
 * R=0 - reset ukoncen      0       1       B       0       D       R       0       0       0       0
 *
 */

int screen_x = 0, screen_y = 0;
extern char font5x7[];

/**
 * intialisation
 */
GLCD_Initalize() {
    int i;
    for (i = 0; i < 3; i++) {
        GLCD_WriteCommand((DISPLAY_ON_CMD | ON), i);
    }
}

/**
 * goto to position
 * @param x valid value 0-127 on 128 pixel display
 * @param y valid value 0-7 on 64 pixel display
 */
GLCD_GoTo(int x, int y) {
    int i;
    screen_x = x;
    screen_y = y;

    for (i = 0; i < 2; i++) { // KS0108_SCREEN_WIDTH / 64
        GLCD_WriteCommand(DISPLAY_SET_X | 0, i);
        GLCD_WriteCommand(DISPLAY_SET_Y | y, i);
        GLCD_WriteCommand(DISPLAY_START_LINE | 0, i);
    }
    if (x >= 64) { // select the right chip
        x -= 64;
        GLCD_WriteCommand(DISPLAY_SET_X | x, 1);
        GLCD_WriteCommand(DISPLAY_SET_Y | y, 1);
    } else {
        GLCD_WriteCommand(DISPLAY_SET_X | x, 0);
        GLCD_WriteCommand(DISPLAY_SET_Y | y, 0);
    }
}

/**
 * blanks whole screen
 */
GLCD_ClearScreen() {
    int i, j;
    for (j = 0; j < 8; j++) { // KS0108_SCREEN_HEIGHT / 8
        GLCD_GoTo(0, j);
        for (i = 0; i < KS0108_SCREEN_WIDTH; i++) {
            GLCD_WriteData(0x00);
        }
    }
}

/**
 * writes char to LCD
 * @param charToWrite
 */
GLCD_WriteChar(int charToWrite) {
    int i;
    char *p;
    charToWrite -= 32;
    charToWrite *= 5;
    for (i = 0; i < 5; i++) {
        p = font5x7 + charToWrite + i;
        GLCD_WriteData(*p);
    }
    GLCD_WriteData(0x00);
}

/**
 * writes null terminated string to display
 * @param stringToWrite
 */
GLCD_WriteString(char *stringToWrite) {
    while (*stringToWrite) {
        GLCD_WriteChar(*stringToWrite++);
    }
}

/**
 * sets one pixel
 * @param x x position
 * @param y y position
 * @param color 0 clears pixel, otherwise sets pixel
 */
GLCD_SetPixel(int x, int y, char color) {
    char tmp;
    GLCD_GoTo(x, (y / 8));
    tmp = GLCD_ReadData();
    //GLCD_GoTo(x, (y / 8));
    if (color) {
        tmp |= 1 << (y % 8); // set dot
    } else {
        tmp &= ~(1 << (y % 8)); // clear dot
    }
    GLCD_WriteData(tmp);
}

/**
 * writes bitmap to specified position
 * @param bmp pointer to bitmap array
 * @param x x position
 * @param y y position
 * @param dx width
 * @param dy height
 */
GLCD_Bitmap(char *bmp, int x, int y, int dx, int dy) {
    char i, j;
    char *ptr;
    for (j = 0; j < dy/8; j++) {
        GLCD_GoTo(x, y + j);
        for (i = 0; i < dx; i++) {
            ptr = bmp++;
            GLCD_WriteData(*ptr);
        }
    }
}

