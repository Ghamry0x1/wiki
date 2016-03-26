`Binders`
---

Binders are similar to pattern in the context of Haskell AST.

Examples:

```haskell
f _ = 1     -- Null Binder
f True = 1  -- Boolean binder, and other primitive binders
f x = x     -- Variable Binder, Ident should be "x"
f (Cons x xs) = x -- Constructor Binder, `Cons` should be name, `x` and `xs` are recursive binders
f { first : x, second : y } = x + y -- Object binder
f [x, y, z] = x + y + z -- Array binder
f l@(Cons x xs) = l     -- Named Binder
f (x :: Int) = 1 :: Int -- Typed Binder

```

------

Comments:

The `Data.Tuple` is in a separate library without special effect. This is intuitive - since JavaScript doesn't provide tuple natively as well.

However, it would be very powerful, if a compiler plugin can be introduced and manipulate over the tuple automatically. For example, `$(a, b, c)` is rewritten as `Tuple (Tuple a b) c`. Binders should also be rewritten, certainly.

And `NullBinder` is a bad name. `WildCardBinder`, or even `UnderScoreBinder` would be far better.


