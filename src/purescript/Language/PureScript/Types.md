`Types`
---

`Skolem` is used to identify type abstractions. <mark>FIXME</mark>: not sure.

From the `data Type`, we can see something about PS's type system:

* `TUnknown Int` reminds me of the mysterious indicator `_0` or `_1` in compiler's error. I think `x`, `a` et cetera can be better.
* `TypeVar String`: Polymorphism
* `TypeWildcard`: Partial type synonym. Well, see [http://stackoverflow.com/questions/4922560/why-doesnt-typesynonyminstances-allow-partially-applied-type-synonyms-to-be-use](http://stackoverflow.com/questions/4922560/why-doesnt-typesynonyminstances-allow-partially-applied-type-synonyms-to-be-use).
* `TypeConstructor`: Higher-order types <mark>FIXME</mark>: not sure
* `TypeApp`: Hask
* `ForAll`: RankNTypes
* `ConstrainedTypes`: Type Class
* `Skolem`: See [http://stackoverflow.com/questions/12719435/what-are-skolems](http://stackoverflow.com/questions/12719435/what-are-skolems). One thing can be sure, `Skolem` is different frm `TUnknown`.
* `REmpry`, `RCons`: Row polymorphism
* `KindedType`: Kind annotation
* And also three "placeholders", which are not important

About "row polymorphism": 

```haskell
> let showPerson { first: x, last: y } = y ++ ", " ++ x
> :type showPerson
forall r. { first :: String, last :: String | r } -> String
```

This means that as long as a record has same fields `first` and `last`, the function application is well-typed. The `r` row is a polymorphic variable.

But type of record is `RCons String Type Type`? It seems to be a recursive construct:

```haskell
rowToList :: Type -> ([(String, Type)], Type)
rowToList (RCons name ty row) = let (tys, rest) = rowToList row
                                in ((name, ty):tys, rest)
rowToList r = ([], r)
```

So, a somewhat unclear `r` will be returned. <mark>FIXME</mark>: How is such `r` treated in inference process.

And a lot of every `everyWhereOnTypesXXX` ... How can I comment ....

------

Comment:

Easy to see, the type system of PureScript is no less than powerful. I think currently the most complex part in the compiler should be type checker ... But here we also have problems:

* Is the checking algorithm efficient?
* Is the type checking pipeline easy to maintain?

The first one effects the compilation speed greatly, while the second one is important, if you want to extend the type system in some way.

