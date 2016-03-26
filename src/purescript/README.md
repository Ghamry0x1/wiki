PureScript Notes
---

Some casual notes about PureScript's implementation for personal studying record.

## Points

1. Best practice in engineering with Haskell
    * Modules
    * Naming Convention
    * Generic Programming
    * Code reuse
    * et cetera
2. Relationship with theory
    * Rewriting
        * Equivalence between PS and JS
        * Intermediate representation
    * Type system
        * How is inference et cetera implemented?
        * How is arbitrary rank implemented?
    * Optimization
        * Tail-call elimination
        * Efficient pattern-matching
        * Compile-time evaluation
        * Inlining
        * Backend specifics (JavaScript)
    * Correctness
        * Exhaustivity
3. Comments
    + Is it a good design?
    + Is it a bad design?
    + Is it a correct implementation?
    + What features should be added in?

    
## Table of Contents

> To structure the "Relationship with theory", I will organize the things as follows

* Syntax [Sugar](./Language/PureScript/Sugar.md)
    + [ObjectWildCards](./Language/PureScript/Sugar/ObjectWildCards.md)
    + [BindingGroups](./Language/PureScript/Sugar/BindingGroups.md)
    + [Operation Sections, Fixity etc.](./Language/PureScript/Sugar/Operators.md)
* AST
    + PureScript AST
        - [Binders](./Language/PureScript/AST/Binders.md)
        - [Declarations](./Language/PureScript/AST/Declarations.md)
* Type System
    + Type Class
        - [TypeClasses](./Language/PureScript/Sugar/TypeClasses.md)
        - [Entailment](./Language/PureScript/TypeChecker/Entailment.md)
        - [TypeClassDictionaries](./Language/PureScript/TypeClassDictionaries.md)
    + [Types](./Language/PureScript/Types.md)
    + Type Checking & Inference
        - [TypeChecker](./Language/PureScript/TypeChecker.md)
* Executables
    + [PSCi](./psci/PSCi.md)
* Build Pipeline
    + [Make](./Language/PureScript/Make.md)
