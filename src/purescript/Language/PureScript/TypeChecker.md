`TypeChecker`
----

Only one thing defined in this file is exported directly: `typeCheckModule`, while the `Monad` etc. is exported with `T`.

## `typeCheckModule`
First, `data Module = Module SourceSpan [Comment] ModuleName [Declaration] (Maybe [DeclarationRef])`.

so, two parts, declarations and exports are checked. The focus is `typeChecAll`.


> Type check all declarations in a module

> At this point, many declarations will have been desugared, but it is still necessary to

> * Kind-check all types and add them to the @Environment@
* Type-check all values and add them to the @Environment@
* Bring type class instances into scope
* Process module imports

### Check `DataDeclaration`
1. If `dtype` is `newtype`, check speciality about newtype
2. Check duplicated type argument, e.g. `data S a a = a`
3. Kinding: e.g. `data S (m :: * -> *) a = S (m a)`

### Check `DataBindingGroupDeclaration`
The `DataBindingGroupDeclaration` has grouped declarations. They are further divided into type synonyms and data decls. And they are kinded. Next, they are added to the environment with `addTypeSynonym` and `addDataType`. 

In `addDataType`, type name is gracefully inserted, and constructors are further added by `addDataConstructor`. First, the type arguments of constructor are fully replaced if any type synonyms exist. Then, its type is constructed and inserted.

Note the `mkForAll`:

```haskell
-- From Language/PureScript/Types.hs
mkForAll :: [String] -> Type -> Type
mkForAll args ty = foldl (\t arg -> ForAll arg t Nothing) ty args
```

The `forall` qualifier for unbounded type variables are all added to the head!

### Check `BindingGroupDeclaration`
Another interesting snippet.

For `BindingGroupDeclaration [(Ident, NameKind, Expr)]`, all identifier are first checked to be **not** defined previously with `valueIsNotDefined`. <mark>It is REALLY a bad name, though</mark>. Then value is typed with `typesOf` and added.

The real code type checking is done with `typesOf` defined in `Language.PureScript.TypeChecker.Types`.

### Check `TypeClassDeclaration`
```haskell
  TypeClassDeclaration (ProperName 'ClassName) [(String, Maybe Kind)] [Constraint] [Declaration]
  -- A type instance declaration (name, dependencies, class name, instance types, member
  -- declarations)
```

Interestingly, the "dependencies" are called `args`.

### Check `TypeInstanceDeclaration`
```haskell
TypeInstanceDeclaration Ident [Constraint] (Qualified (ProperName 'ClassName)) [Type] TypeInstanceBody
  -- A type instance declaration (name, dependencies, class name, instance types, member
  -- declarations)
```

Let's see `checkTypeClassInstance`. It can return two errors:

* `TypeSynonymInstance`: Type synonym name is used as `TypeConstructor`.
* `InvalidInstanceHead`: The $\alpha$ is not in `TypeVar`, `TypeConstructor` or `TypeApp`.

After that, we we will check its named constraints. Then `checkOrphanInstance` (<mark>FIXME</mark> *WTF does this mean*? all I see is check the consistency of module name).

-----

Comments:

This module reflects the complexity of type system. The existence of other language construct makes typing more complex; while at the same time, we make typing itself complex in exchange for expressiveness.

Also, this part is more specific to the language itself. The core of type checking algorithm might be more independent.
