/**
 * Small-C expressions Test Program
 *
 * This program tests the operators of Small-C language.
 */

int *agp;
char *bgp;
int ar[5] = {1, 2, 3, 4, 5};
char br[6] = {'a', 'b', 'c', 'd', 'e'};

struct sb {
    unsigned int as;
    int bs;
    unsigned char cs;
    char ds;
};

struct sb strct_bs = {34567, -23456, 'a', -123}, *stbp;
struct sb strct_br[5];

test_expr_suite() {
    strct_br[1].as = 50178;
    
    test_ptr_arit();
    test_int_arit();
}

test_ptr_arit() {
    struct sb *slbp;
    int *alp;
    char *blp;
    
    /* First test all possible combinations of pointers. */
    printf("Testing int pointer arithmetics");
    agp = &ar[2] - 2;
    if ((*agp < 2) && (*agp > 0)) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing int pointer arithmetics");
    agp += 2;
    if ((*agp < 4) && (*agp > 2)) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing int pointer arithmetics");
    agp = ar + 2;
    agp -= 2;
    if ((*agp < 2) && (*agp > 0)) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing int pointer arithmetics");
    agp += 2;
    if ((*agp < 4) && (*agp > 2)) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing int local pointer arithmetics");
    alp = ar + 2;
    alp -= 2;
    if ((*alp < 2) && (*alp > 0)) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing int local pointer arithmetics");
    alp += 2;
    if ((*alp < 4) && (*alp > 2)) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing char pointer arithmetics");
    bgp = &br[2];
    bgp -= 2;
    if (*bgp == 'a') {
        writeOK();
    } else {
        writeNOK();
    }

    printf("Testing char pointer arithmetics");
    bgp++;
    ++bgp;
    if (*bgp != 'c') {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing char pointer arithmetics");
    bgp = br + 2;
    bgp -= 2;
    if (*bgp == 'a') {
        writeOK();
    } else {
        writeNOK();
    }

    printf("Testing char pointer arithmetics");
    bgp++;
    ++bgp;
    if (*bgp != 'c') {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing char local pointer arithmetics");
    blp = br + 2;
    blp -= 2;
    if (*blp == 'a') {
        writeOK();
    } else {
        writeNOK();
    }

    printf("Testing char local pointer arithmetics");
    blp++;
    ++blp;
    if (*blp != 'c') {
        writeNOK();
    } else {
        writeOK();
    }
    
    printf("Testing struct pointer arithmetics");
    stbp = strct_br + 2;
    stbp -= 1;
    if (stbp->as == 50178) {
        writeOK();
    } else {
        writeNOK();
    }

    printf("Testing struct pointer arithmetics");
    stbp = &strct_br[0] + 2;
    stbp -= 1;
    if ((stbp->as > 50177) && (stbp->as < 50179)) {
        writeOK();
    } else {
        writeNOK();
    }
    
    printf("Testing locale struct pointer arithmetics");
    slbp = strct_br + 2;
    slbp -= 1;
    if (slbp->as == 50178) {
        writeOK();
    } else {
        writeNOK();
    }

    printf("Testing struct pointer arithmetics");
    slbp = &strct_br[0] + 2;
    slbp -= 1;
    if ((slbp->as > 50177) && (slbp->as < 50179)) {
        writeOK();
    } else {
        writeNOK();
    }
}

test_int_arit() {
}


