## Condtion Tables

The `ableC` extensions adds so-called condition tables; these are
useful in specifying complicated Boolean expressions.  Condition
tables are provided in requirements engineering languages such as
RSML-e and SCR.  They have been shown to be effecting in presenting
complex specifications to domain-experts, such as pilots or air
traffic controls in the avionics domain[1-3].

A simple example is shown in `examples/simple.xc`.  An example of an
altitude switch that uses condition tables can be found in
`examples/altitude_switch.xc`.


Below is a sample condition table, from `examples/simple.xc` that
references three Boolean values `b1`, `b2`, and `b3`.

```
    int c1 = table { b1 && b3 : T F
                     ! b2     : T *
                     b2 || b3 : F T };
```

This table is semantically equivalent to this less intuitive
expression.
```
    int c2 = ((b1 && b3) && ((! b2) && (!(b2 || b3)))) || 
             ((!(b1 && b3)) && (1 && (b2 || b3)));
```
In the actual translation of these tables to plain C code, expressions
in the table are not evaluated twice because they may contain side
effects. 


### References
[1] Heninger, K.: Specifying software requirements for complex
systems: New techniques and their application. IEEE Trans. on Software
Engin. 6(1) (1980) 2–13.

[2] Leveson, N., Heimdahl, M., Hildreth, H., Reese, J.: Requirements
Specification for Process-Control Systems. IEEE Trans. on Software
Engin. 20(9) (1994) 684–706.

[3] Zimmerman, M.K., Lundqvist, K., Leveson, N.: Investigating the
readability of state-based formal requirements specification
languages. In: Proc. 24th Intl. Conf.on Software Engineering, ACM
Press (2002) 33 – 43.
