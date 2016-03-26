`Sugar.md`
----


> The desugaring pipeline proceeds as follows:

> * Remove signed literals in favour of `negate` applications
* Desugar object literals with wildcards into lambdas
* Desugar operator sections
* Desugar do-notation using the @Prelude.Monad@ type class
* Desugar top-level case declarations into explicit case expressions
* Desugar type declarations into value declarations with explicit type annotations
* Qualify any unqualified names and types
* Rebracket user-defined binary operators
* Introduce type synonyms for type class dictionaries
* Group mutually recursive value and data declarations into binding groups.


-----

Comment: what I don't understand:

* Desugar operator sections: `desugarOperatorSections`
* Rebracket user-defined binary operators: `rebracket`
* Introduce type synonyms for type class dictionaries: `desugarTypeClasses`



