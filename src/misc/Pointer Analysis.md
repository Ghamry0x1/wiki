# Pointer Analysis

> What memory locations can a pointer refer to?


Alias analysis: When do two pointer expressions refer to the same storage location?

Aliasing can arise due to

* Pointers
* Call-by-ref
* Array Indexing

Pointer analysis is useful in

* Available Expressions
* Constant Propagation


### Flow-sensitive v.s. flow-insensitive
The former one will compute for each program point what memory locations some pointer expr might refer to

The later one will determine at some moment during execution.


### Definiteness
**May analysis**: aliasing that may occur during execution (cf. must-not alias, although often has different representation)


**Must analysis**: aliasing that must occur during execution

Sometimes both are useful* E.g., Consider liveness analysis for *p = *q + 4;* If *p must alias x, then x in kill set for statement* If *q may alias y, then y in gen set for statement

Why above?

