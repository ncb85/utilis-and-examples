/**
 * buggy.c
 */


int i = 0;
unsigned int iu = 0;
char buffers[6], p;
unsigned char bufferu[6], pu;
char backspaces[] = {0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x00};
unsigned char bsckspacesu[] = {0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x00};
int day, hour, minute, second, old_second, tick;
unsigned int dayu, houru, minuteu, secondu, old_secondu, ticku;
int second_x, second_y, offsets[] = {0, 3, 6, 9, 11, 13, 15, 17, 18, 19, 20, 21, 22, 23, 24, 24};
extern char color;
extern unsigned char coloru;

/**
 * xyz routine
 * @return
 */
xyz() {
    day = hour = minute = second = tick = 0;
}

arr_param(char an_array[]) {
    an_array[4] = 'x';
}