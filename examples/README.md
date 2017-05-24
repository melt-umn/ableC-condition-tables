This directory contains files to build an instance of ableC extended
with this extension.

To create the extended compiler that uses this extension run the
following:
```
   make ableC.jar
```

This artifact may then be used on the examples in investigating how
the extension works.  To compile the two correct sample files,
`simple.xc` and `altitude_switch.xc` they the following commands:
```
   make simple.out
   make altitude_switch.out
```
Then run this generated executables.

Two semantically incorrect examples can also be found here.  The table
in `type_error.xc` demonstrates the type errors that are generated if
an expression in the table is not a Boolean.  The table in
`mismatched_rows.xc` shows that all rows in a table must have the same
number of T/F/* flags.

To see the error messages produced by ableC, run the following:
```
   make type_error.c
   make mismatched_rows.c
```
Both of these will fail to create the C translation due to the
semantics errors in each.

