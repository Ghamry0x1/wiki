`ObjectWildCards`
---


> One-liner: See `RecordWildCards`.

`desugarObjectConstructors` is a module desugarer `Module -> m Module`. Since the syntax sugar in only in expression, so `desugarExpr :: Expr -> m Expr` is the core.

Here the `Expr` has four cases:

* `ObjectConstructor [(String, Maybe Expr)]`: An object constructor (object literal with underscores). This will be removed during desugaring and expanded into a lambda that returns an object literal.
* `ObjectUpdater`: If something, become lambda that `ObjectUpdate`; If nothing, wrap another layer of abstraction
* `ObjectGetter`: Wrap into a lambda like `\arg -> arg.prop`
* others: remain same

`wrapLambda`: It is basically a filter. When all fields are `Just _`, it simply use the callback maker to make the returned `Expr`. But for `Nothing`s, or undefined fields in constructor, the identifiers are used as abstractions wrapping the innermost made `Expr`.

`mkProp`: It is used in `wrapLambda` to facilitate the construction of lambdas. Note in the second branch `(Just arg, (name, Var (Qualified Nothing arg)))`, `arg` is a fresh binder.

--- 

Comments:

I don't find description about this feature in recent-most *PureScript by Example*, but here is the [pull request](https://github.com/purescript/purescript/pull/847) and [an issue](https://github.com/purescript/purescript/issues/861). Note:

> Record literals with wildcards can be used to create a function that produces the record instead:

> ```
> { foo: _, bar: _ }
> ```
> is equivalent to:
>
```
\foo bar -> { foo: foo, bar: bar }
```
And for updater, it either has an already know target `obj`, or turned into a lambda.

The getter is similar to turning a field name into a accessor lambda (since accessor itself is not function).



