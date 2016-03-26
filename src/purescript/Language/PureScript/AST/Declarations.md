`Declarations`
---

The rest of PureScript AST except for `Binder` is all here.



### First, something not usual

```haskell
data DeclarationRef
    = TypeRef (ProperName 'TypeName) (Maybe [ProperName 'ConstructorName])
    | ...


-- From Names.hs
newtype ProperName (a :: ProperNameType)
      = ProperName { runProperName :: String }
```

Ok, WTF is `'TypeName`?

It is defined here

```haskell
data ProperNameType = TypeName | ConstructorName | ClassName | Namespace
```

Actually, this is a use case of `DataKinds` extension. The `ProperNameType` is a *kind*, and `TypeName` is *kind constructor*. So you can put things like `Int` (which is a *type*) in the *kind constructor*, for example

```haskell
x :: DeclarationRef
x = TypeRef (ProperName "x" :: ProperName TypeName) (Maybe [ProperName "x" :: ProperName ConstructorName])
```

Basically, it is attaching name with type-level information, so you won't mess the code up.

See [http://stackoverflow.com/questions/20558648/what-is-the-datakinds-extension-of-haskell](http://stackoverflow.com/questions/20558648/what-is-the-datakinds-extension-of-haskell) for an excellent explanation.


### `DeclarationRef`
One thing to note is the fact that import and export are essentially symmetrical, so it can be represented uniformly.

`findDuplicateRefs`: First, I found use of `stripPosInfo` pretty annoying - maybe there is a way of programming without such concern? Second, why should we find such duplicates? In `Sugar/Names/Export` and `Sugar/Names/Import`, you can see it is just used for warning.

### `Declaration`
Interestingly, `DataDeclType` can be both `Data` and `Newtype`. But shouldn't newtype have just one constructor which takes just one argument? Is it a good design to make them orthogonal? My idea: by unifying this, `newtype` is essentially a syntax sugar which is only known to parser. It becomes easier to do transformations later on with a single type of `data`. Optimization can be done uniformly.

#### About `NameKind`:

```haskell
data NameKind
  -- A private value introduced as an artifact of code generation (class instances, class member
  -- accessors, etc.)
  = Private
  -- A public value for a module member or foreing import declaration
  | Public
  -- A name for member introduced by foreign import
  | External
```

Note: `Guard` is also an `Expr`, but its type will be checked to be `Bool`.

Note: `qualified` seems deprecated. It seems that the PureScript team wants to make module first-class, so a unified renaming could be used rather than a extra `qualified`.

Note: `DerivedInstance` is not much useful here. Since template PureScript is not ready.

Note: The `isFixityDecl` etc. look very boilerplate ....

### `Expr`
The `NumericLiteral` looks not very ideal at least to me ... It is a decision made halfway by PS team and now you have to do casting manually.

Another thing -- Something will be "removed during desugaring", such as `ObjectGetter String`, so it can be a problem if you are reusing this AST somewhere else.

#### About `TypeClassDictionary`
Take a look at [http://okmij.org/ftp/Computation/typeclass.html](http://okmij.org/ftp/Computation/typeclass.html).

So, type class compilation has basically two methods:

1. Dictionary pass, or Monomorphization, or type classes as macros
2. Intensional type analysis

In JavaScript, the dictionary can be implemented with Object. For every *class* or constraint, the dictionary will be indexed by type name. Interestingly, here the type is imprecise -- Although author certainly only want `ObjectLiteral`, but he has to write `Expr` here.

```haskell
type Constraint = (Qualified (ProperName 'ClassName), [Type])
```

Note: `Language.PureScript.TypeClassDictionaries` has other definitions about type class.

The point is to understand "placeholder" -- a compile time hole to be filled with simple object later. The placeholder contains information necessary to determine how to access the object.

I am not very clear about the process, but it seems like:

    SuperClass -> TypeClass -> TypeClassAccessor -> ObjectLiteral

#### About `CaseAlternative`
Two kinds:

* Destruction: `case ... of`
* Guard: `| a == b = c | ...`

> During the case expansion phase of desugaring, top-level binders will get desugared into case expressions, hence the need for guards and multiple binders per branch here.

```haskell
data X = A Int | B Int

example :: X -> Int
example x = case x of
    A y | y == 1    -> 2
    B z | z == 2    -> 1
        | otherwise -> 0
```


