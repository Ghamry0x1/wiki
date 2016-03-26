`TypeClasses.md`
-----


```haskell
type MemberMap = M.Map (ModuleName, ProperName 'ClassName)
                       ([(String, Maybe Kind)], [Constraint], [Declaration])
```

I don't understand that why it is an array of such `(String, Maybe Kind)` pair?

This line of code can give us some hint:

```haskell
fromExternsDecl mn (EDClass name args members implies) =
    Just ((mn, name),
          (args, implies, map (uncurry TypeDeclaration) members))
```

I see, it is because PureScript supports `MultiParamTypeClasses` by default.


`desugarModule` is simply arrange the order of declarations and desugar them in order.

> Type classes become type synonyms for their dictionaries, and type instances become dictionary declarations.
> Additional values are generated to access individual members of a dictionary, with the appropriate type.

And there is a very detailed explanation in source, which I recommend you to look.

The superclass is interesting:

```haskell
type Sub a = { sub :: a
             , "__superclass_Foo_0" :: {} -> Foo a
             }
```

First, this is an extensible record; the "inheritance" is implemented with *including*.

```haskell
desugarDecl mn exps = go
  where
  go d@(TypeClassDeclaration name args implies members) = ...
  go ...
```
this is a good pattern -- since `mn` and `exps` don't have to be matched, so they are bound to `desugarDecl` while the pattern-matching is done in a helper `go`, which helps use to write more concise code.

Note: In these desugarings, we need to return a `DeclarationRef` as well. It might mean that, although some declaration might not be really exported, but we need to know its exported form -- so as to match the exporting requirements?

---

Comments:

This is the core of dictionary-based implementation of type class. Although the idea is very simple, the actual code looks still rather messy. Basically, it is full of deconstruct and construct. There is some efforts done in generic programming to alleviate the pain, but can we go further?

Is there any possibility of generating these kind of code from some more concise and readable code? Can we push the generic programming over AST a step further -- into generic programming over translation (desugar et cetera or any operations in the same domain, or maybe different domain)?







