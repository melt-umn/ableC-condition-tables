#include <stdio.h>

int main() {

    /* This table is incorrect because the 2nd row has more T/F/*
       flags than the other two rows. */

    int b = table { 1 : T F *
                    0 : F * F F 
                    1 : T * F };
}
