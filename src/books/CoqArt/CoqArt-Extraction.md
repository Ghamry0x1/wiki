# Coq-Art Extraction
 Two challenges:

1. Due to use of dependent type etc., the well-types programs in Coq might not be correct in target.
2. Functions in the CoC may contain logical aspects, which is not related to computation.



Two operations performed in extracting an object of CoC:

1. Inductive type: removing the type and proof arguments from the constructors
2. Functions or values: Type expressions are removed; proofs expressions are removed or sometimes replaced by a unique value.

In Coq, polymorphism is expressed with dependent types, while polymorphic type parameters are given in OCAML.

Ex 10.1

```ocaml
type 'a option=
    | Some of 'a * 'a option
    | None of 'a option

let rec nth' l n = match l, n of
    | nil, _           -> None
    | cons(a, tl), 0   -> Some a
    | cons(a, tl), S p -> nth'(tl, p).

```

? What does "Implicit Arguments" in Coq means? I suppose it is used in polymorphic definitions, as serve as a way to omit some related notations.

Problem about pattern matching and proof irrelevance:

```
Definition or_to_nat (A,B:Prop)(A∨B) : nat :=

Mapping from proofs of `sumbool` types to proofs of `or` types.

```
Definition sumbool_to_or (A B:Prop)(v:{A}+{B}) : A∨B :=
  match v with
```