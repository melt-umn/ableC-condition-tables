#include <stdio.h>

struct foo { int x; } y;

int main() {

    /* This generates a type error since the expressions in the table
       rows must be a boolean value. */ 
    int b = table { y : T * F } ;

}
