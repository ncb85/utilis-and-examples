/**
 * file: graphic.c
 * graphical routinnes for KS0108 GLCD
 */

#define COLOR 1

/**
 * draws a rectangle
 * @param x origin x
 * @param y origin y
 * @param b width
 * @param a height
 */
GLCD_Rectangle(int x, int y, int b, int a) {
    char j; // zmienna pomocnicza
    // rysowanie linii pionowych (boki)
    for (j = 0; j < a; j++) {
        GLCD_SetPixel(x, y + j, COLOR);
        GLCD_SetPixel(x + b - 1, y + j, COLOR);
    }
    // rysowanie linii poziomych (podstawy)
    for (j = 0; j < b; j++) {
        GLCD_SetPixel(x + j, y, COLOR);
        GLCD_SetPixel(x + j, y + a - 1, COLOR);
    }
}

/**
 * draws a circle using Bresenham midpoint circle algorithm
 * @param cx
 * @param cy
 * @param radius
 */
GLCD_Circle(int cx, int cy, int radius) {
    int x, y, xchange, ychange, radiusError;
    x = radius;
    y = 0;
    xchange = 1 - 2 * radius;
    ychange = 1;
    radiusError = 0;
    while (x >= y) {
        GLCD_SetPixel(cx + x, cy + y, COLOR);
        GLCD_SetPixel(cx - x, cy + y, COLOR);
        GLCD_SetPixel(cx - x, cy - y, COLOR);
        GLCD_SetPixel(cx + x, cy - y, COLOR);
        GLCD_SetPixel(cx + y, cy + x, COLOR);
        GLCD_SetPixel(cx - y, cy + x, COLOR);
        GLCD_SetPixel(cx - y, cy - x, COLOR);
        GLCD_SetPixel(cx + y, cy - x, COLOR);
        y++;
        radiusError += ychange;
        ychange += 2;
        if (2 * radiusError + xchange > 0) {
            x--;
            radiusError += xchange;
            xchange += 2;
        }
    }
}

/**
 * draws a line from point 1 to point 2 using Bresenham line algorithm
 * @param X1 first point
 * @param Y1 first point
 * @param X2 second point
 * @param Y2 second point
 */
GLCD_Line(int X1, int Y1, int X2, int Y2) {
    int CurrentX, CurrentY, Xinc, Yinc,
            Dx, Dy, TwoDx, TwoDy,
            TwoDxAccumulatedError, TwoDyAccumulatedError;

    Dx = (X2 - X1); // obliczenie składowej poziomej
    Dy = (Y2 - Y1); // obliczenie składowej pionowej

    TwoDx = Dx + Dx; // podwojona składowa pozioma
    TwoDy = Dy + Dy; // podwojona składowa pionowa

    CurrentX = X1; // zaczynamy od X1
    CurrentY = Y1; // oraz Y1

    Xinc = 1; // ustalamy krok zwiększania pozycji w poziomie
    Yinc = 1; // ustalamy krok zwiększania pozycji w pionie

    if (Dx < 0) { // jesli składowa pozioma jest ujemna
        Xinc = -1; // to będziemy się "cofać" (krok ujemny)
        Dx = -Dx; // zmieniamy znak składowej na dodatni
        TwoDx = -TwoDx; // jak również podwojonej składowej
    }

    if (Dy < 0) { // jeśli składowa pionowa jest ujemna
        Yinc = -1; // to będziemy się "cofać" (krok ujemny)
        Dy = -Dy; // zmieniamy znak składowej na dodatki
        TwoDy = -TwoDy; // jak równiez podwojonej składowej
    }

    GLCD_SetPixel(X1, Y1, COLOR); // stawiamy pierwszy krok (zapalamy pierwszy piksel)

    if ((Dx != 0) || (Dy != 0)) { // sprawdzamy czy linia składa się z więcej niż jednego punktu ;)
        // sprawdzamy czy składowa pionowa jest mniejsza lub równa składowej poziomej
        if (Dy <= Dx) { // jeśli tak, to idziemy "po iksach"
            TwoDxAccumulatedError = 0; // zerujemy zmienną
            do { // ruszamy w drogę
                CurrentX += Xinc; // do aktualnej pozycji dodajemy krok
                TwoDxAccumulatedError += TwoDy; // a tu dodajemy podwojoną składową pionową
                if (TwoDxAccumulatedError > Dx) { // jeśli TwoDxAccumulatedError jest większy od Dx
                    CurrentY += Yinc; // zwiększamy aktualną pozycję w pionie
                    TwoDxAccumulatedError -= TwoDx; // i odejmujemy TwoDx
                }
                GLCD_SetPixel(CurrentX, CurrentY, COLOR); // stawiamy następny krok (zapalamy piksel)
            } while (CurrentX != X2); // idziemy tak długo, aż osiągniemy punkt docelowy
        } else { // w przeciwnym razie idziemy "po igrekach"
            TwoDyAccumulatedError = 0;
            do {
                CurrentY += Yinc;
                TwoDyAccumulatedError += TwoDx;
                if (TwoDyAccumulatedError > Dy) {
                    CurrentX += Xinc;
                    TwoDyAccumulatedError -= TwoDy;
                }
                GLCD_SetPixel(CurrentX, CurrentY, COLOR);
            } while (CurrentY != Y2);
        }
    }
}

