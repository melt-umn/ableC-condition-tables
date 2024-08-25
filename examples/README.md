This directory contains files to build an instance of ableC extended
with this extension.

To compile the extension specification, first run following in the parent directory:
```
   make build
```

To see how to build an extended compiler that uses the extension,
and compile and run the two correct sample files,
`simple.xc` and `altitude_switch.xc`, run the `build-and-run` script:
```
   ./compile-and-run
```
Then run this generated executables.

Two semantically incorrect examples can also be found in the `tests/translate_error`
subfolder of the extension root directory.  The table
in `type_error.xc` demonstrates the type errors that are generated if
an expression in the table is not a Boolean.  The table in
`mismatched_rows.xc` shows that all rows in a table must have the same
number of T/F/* flags.

To see the error messages produced by ableC, run the following:
```
   java -jar compiler.jar ../tests/translate_error/mismatched_rows.xc
   java -jar compiler.jar ../tests/translate_error/type_error.xc
```
Both of these will fail to create the C translation due to the
semantics errors in each.

