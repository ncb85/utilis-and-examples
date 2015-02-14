/*
 * File:   main.c, february 2014
 * smallC test suite
 */

unsigned int pass = 0;
signed int fail = 0;

writeOK() {
    printf("\tValid\n");
    pass++;
}

writeNOK() {
    printf("\t****Invalid\n");
    fail++;
}

/**
 * main routine
 * @return
 */
main() {
    unsigned char sum;
    unsigned int isum;

    printf("printf test %d\n", 9999);
    printf("**********(Signed Tests)**********\n");
    teqs();		/* equal */
    tnes();		/* not equal */
    tges();		/* greater than or equal to */
    tles();		/* less than or equal to */
    tgts();		/* greater than */
    tlts();		/* less than */
    printf("*****(Signed Tests Completed)*****\n");

    printf("**********(Unsigned Tests)**********\n");
    test_unsigned();
    printf("*****(Unsigned Tests Completed)*****\n");

    printf("*****(Function Param/Return Tests)*****\n");
    sum = test_K_and_R(1,2,3,4);
    printf("Testing K&R return");
    if (sum == 10) {
        writeOK();
    } else {
        writeNOK();
    }
    isum = test_ansi(1,2,3,4);
    printf("Testing ANSI return");
    if (isum == 10) {
        writeOK();
    } else {
        writeNOK();
    }
    printf("*****(Function Param/Return Completed)*****\n");
    
    printf("*****(Function Struct/Union Tests)*****\n");
    test_struct_suite();
    printf("*****(Function Struct/Union Completed)*****\n");

    printf("*****(Pointer, Reference, Dereference Tests)*****\n");
    test_pointer_suite();
    printf("*****(Pointer, Reference, Dereference Completed)*****\n");
    
    printf("*****(Expression and Pointer Tests)*****\n");
    test_expr_suite();
    printf("*****(Expression and Pointer Completed)*****\n");
            
    printf("*****Total Number of Tests:*****");
    printf("%d\n", pass+fail);
    printf("*****Passed/Failed Tests:*****");
    printf("%d/%d\n", pass, fail);
}
