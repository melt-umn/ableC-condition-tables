#include <stdio.h>

int main() {

    // 3 simple Boolean values
    int b1 = 1;
    int b2 = 0;
    int b3 = 1;

    // A condition table
    int c1 = table { b1 && b3 : T F
                     ! b2     : T *
                     b2 || b3 : F T };

    // This table is equivalent to this less intuitive expression.
    int c2 = ((b1 && b3) && ((! b2) && (!(b2 || b3)))) || 
             ((!(b1 && b3)) && (1 && (b2 || b3)));

    if (c1 == c2) {
        printf ("Correct - they are the same.\n");
        return 0;
    }
    else {
        printf ("Incorrect - they are different.\n");
        return 1;
    }
}
