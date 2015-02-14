

#define CENTER_X 100
#define CENTER_Y 35

char color;
int modified_octets[75];
char disp_buff[1024];
int length = 0;

int offsets[] = {
/*int hands24[] = {*/0, 3, 5, 7, 10, 12, 14, 16, 18, 19, 21, 22, 23, 23, 24, 24,
/*int hands23[] = {*/0, 2, 5, 7, 9 , 11, 14, 15, 17, 19, 20, 21, 22, 22, 23, 23,
/*int hands22[] = {0, 2, 5, 7, 9 , 11, 13, 15, 16, 18, 19, 20, 21, 22, 22, 22,                     
/*int hands20[] = {0, 2, 4, 6, 8 , 10, 12, 13, 15, 16, 17, 18, 19, 20, 20, 20,*/
/*int hands18[] = {*/0, 2, 4, 6, 7 ,  9, 11, 12, 13, 15, 16, 16, 17, 18, 18, 18};

unsigned char old_hour = 12, old_minute = 60, old_second = 60;

/**
 * draw hour and minute hands
 * @param type length of the hand, 0 - second, 1 - minute, 2 - hour
 * @param time the position of the hand (0..59)
 */
draw_clock_hand(int type, int time) {
    int x, y, hand_idx;
    if (time < 0) {
        time = 59;
    }
    hand_idx = type << 4; // 16 time multiply - pick one hand from two dim array
    if (time < 15) {
        x = CENTER_X + offsets[hand_idx + time];
        y = CENTER_Y - offsets[hand_idx + 15 - time];
    } else if (time < 30) {
        time -= 15;
        x = CENTER_X + offsets[hand_idx + 15 - time];
        y = CENTER_Y + offsets[hand_idx + time];
    } else if (time < 45) {
        time -= 30;
        x = CENTER_X - offsets[hand_idx + time];
        y = CENTER_Y + offsets[hand_idx + 15 - time];
    } else {
        time -= 45;
        x = CENTER_X - offsets[hand_idx + 15 - time];
        y = CENTER_Y - offsets[hand_idx + time];
    }
    GLCD_Clock_Line(CENTER_X, CENTER_Y, x, y);
}

/**
 * note which display octets have been modified
 * @param octet_number
 */
add_to_modified(int octet_number) {
    int i;
    for (i=0; i<length; i++) {
        if (octet_number == modified_octets[i]) {
            return;
        }
    }
    modified_octets[length] = octet_number;
    length++;
}

/**
 * dump buffer to lcd screen
 */
GLCD_DumpScreen() {
    int i, x, y, octet;
    for (i = 0; i < length; i++) {
        octet = modified_octets[i];
        // if consecutive display cells in buffer avoid GoTo to speed up
        if ((i == 0) || (octet != modified_octets[i-1] + 1)) {
            x = octet % 128;
            y = octet / 128;
            GLCD_GoTo(x, y);
        }
        GLCD_WriteData(disp_buff[octet]);
    }
}

/**
 * sets pixels in buffer
 * @param x
 * @param y
 * @return 
 */
GLCD_Clock_SetPixel(int x, int y) {
    int octet_number;
    char content;
    octet_number = ((y / 8) << 7) + x;
    content = disp_buff[octet_number];
    if (color) {
        content |= 1 << (y % 8);
    } else {
        content &= ~(1 << (y % 8));
    }
    if (disp_buff[octet_number] != content) {
        add_to_modified(octet_number);
        disp_buff[octet_number] = content;
    }
}

/**
 * draws a line from point 1 to point 2 using Bresenham line algorithm
 * @param X1 first point
 * @param Y1 first point
 * @param X2 second point
 * @param Y2 second point
 */
GLCD_Clock_Line(int X1, int Y1, int X2, int Y2) {
    int CurrentX, CurrentY, Dx, Dy, TwoDx, TwoDy, Yinc,
            TwoDxAccumulatedError, TwoDyAccumulatedError;

    Dx = (X2 - X1); // delta
    Dy = (Y2 - Y1); //

    if (Dx < 0) { // x from right to left
        GLCD_Clock_Line(X2, Y2, X1, Y1);
        return;
    }

    TwoDx = Dx + Dx; // doubled delta
    TwoDy = Dy + Dy; //

    CurrentX = X1; // start position
    CurrentY = Y1; //
    
    Yinc = 1;

    if (Dy < 0) { // down to top direction
        Yinc = -1; // backwards
        Dy = -Dy; // change sign
        TwoDy = -TwoDy;
    }

    GLCD_Clock_SetPixel(X1, Y1);

    if ((Dx != 0) || (Dy != 0)) { // size test
        // we will step in direction of bigger delta
        if (Dy <= Dx) { // stepping x, computing y
            TwoDxAccumulatedError = 0;
            do {
                CurrentX += 1;
                TwoDxAccumulatedError += TwoDy;
                if (TwoDxAccumulatedError > Dx) {
                    CurrentY += Yinc;
                    TwoDxAccumulatedError -= TwoDx;
                }
                GLCD_Clock_SetPixel(CurrentX, CurrentY);
            } while (CurrentX != X2);
        } else { // stepping y, computing x
            TwoDyAccumulatedError = 0;
            do {
                CurrentY += Yinc;
                TwoDyAccumulatedError += TwoDx;
                if (TwoDyAccumulatedError > Dy) {
                    CurrentX += 1;
                    TwoDyAccumulatedError -= TwoDy;
                }
                GLCD_Clock_SetPixel(CurrentX, CurrentY);
            } while (CurrentY != Y2);
        }
    }
}

/**
 * displays analog clock on GCLD
 * @param hour
 * @param minute
 * @param second
 * @return 
 */
display_analog_clock(unsigned char hour, unsigned char minute, unsigned char second) {
    static unsigned char fixed_hour;
    length = 0;
    if (hour > 11) {
        hour -= 12;
    }
    fixed_hour = 5 * hour + minute / 12;
    color = 0;
    draw_clock_hand(2, old_hour);
    draw_clock_hand(1, old_minute);
    draw_clock_hand(0, old_second);
    color = 1;
    draw_clock_hand(2, fixed_hour);
    draw_clock_hand(1, minute);
    draw_clock_hand(0, second);
    GLCD_DumpScreen();
    old_hour = fixed_hour;
    old_minute = minute;
    old_second = second;
}

init_analog_clock() {
    // draw clock
    color = 1;
    // 0,15,30,45 minutes
    GLCD_Clock_Line(CENTER_X, 9, CENTER_X, 10);
    GLCD_Clock_Line(CENTER_X, 60, CENTER_X, 61);
    GLCD_Clock_Line(74, CENTER_Y, 75, CENTER_Y);
    GLCD_Clock_Line(125, CENTER_Y, 126, CENTER_Y);
    // 5 minutes
    GLCD_Clock_SetPixel(CENTER_X+12, CENTER_Y-25+3);
    // 10 minutes
    GLCD_Clock_SetPixel(CENTER_X+22, CENTER_Y-24+12);
    // 20 minutes
    GLCD_Clock_SetPixel(CENTER_X+22, CENTER_Y+24-12);
    // 25 minutes
    GLCD_Clock_SetPixel(CENTER_X+12, CENTER_Y+25-3);
    // 40 minutes
    GLCD_Clock_SetPixel(CENTER_X-22, CENTER_Y+24-12);
    // 35 minutes
    GLCD_Clock_SetPixel(CENTER_X-12, CENTER_Y+25-3);
    // 50 minutes
    GLCD_Clock_SetPixel(CENTER_X-22, CENTER_Y-24+12);
    // 55 minutes
    GLCD_Clock_SetPixel(CENTER_X-12, CENTER_Y-25+3);
    GLCD_DumpScreen();
}