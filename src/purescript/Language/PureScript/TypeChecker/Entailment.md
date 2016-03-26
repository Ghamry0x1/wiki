`Entailment`
---

> entail: involve (something) as a necessary or inevitable part or consequence: *a situation which entails considerable risks.*

> `entail`: Check that the current set of type class dictionaries entail the specified type class goal, and, if so, return a type class dictionary reference.

So, it is typeclass related. It arguments:

* `moduleName : ModuleName`: <mark>FIXME</mark> Where it is used?
* `context : M.Map (Maybe ModuleName) (M.Map (Qualified (ProperName 'ClassName)) (M.Map (Qualified Ident) TypeClassDictionaryInScope))`
    + Too long name
    + Basically a $module \mapsto (class \mapsto (ident \mapsto dictionary))$
* `Constraint`: `(Qualified (ProperName 'ClassName), [Type])`

So, "type class goal" is the constraint. `solve` either solve it and return `Expr` which is a plain–value form of type class.

The `Int` type `work` looks interesting to me. If `work` is too large (>1000), a `PossiblyInfiniteInstance` error will be triggered. Pay attention to `solveSubgoals`, which creates dictionaries for subgoals which still need to be solved by calling go recursively. E.g. the goal `(Show a, Show b) => Show (Either a b)` can be satisfied if the current type unifies with `Either a b`, and we can satisfy the subgoals `Show a` and `Show b` recursively.

One point is the relationship between "super class" and "sub class". 

<mark>TODO</mark>: Maybe I should read the original paper of Haskell to make context a little clearer.

* `overlapping`'s motivation:  Dictionaries which are *subclass dictionaries* cannot overlap.
* `mkDictionary`'s branching is interesting: It is used with `args`, which are returned value of `solveSubgoal`, and later used as initial part of `foldr`.
    + If `solveSubgoal` is passed with no constraints, dictionary value is local
    + If empty `args`, dictionary value is global
    + If empty `args`, dictionary value is dependent

So, can you tell me what does `solve` do?

> Every type is checked to satisfy the constraint under the context. Type can be base type $\tau$ or constructed type $\kappa \, \tau$. For the base type, it is simply queried; For the constructed type, we will query its constructor. The constructor might be polymorphic. But the one with instance must be more polymorphic. Beyond that, the typeclass's superclass might bring other constraints, which should be solved.

`typeHeadsAreEqual`: What is "type heads"? `Skolem` and `TypeConstructor` are referred. Row constructor `RCons` is also used. I think it wants to extract what would be used in type class declaration, i.e. the $\alpha$. The $\alpha$ can be parameterized.


