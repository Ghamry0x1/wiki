`TypeClassDictionaries`
-----

```haskell
data TypeClassDictionaryInScope
  = TypeClassDictionaryInScope {
    -- | The identifier with which the dictionary can be accessed at runtime
      tcdName :: Qualified Ident
    -- | How to obtain this instance via superclass relationships
    , tcdPath :: [(Qualified (ProperName 'ClassName), Integer)]
    -- | The name of the type class to which this type class instance applies
    , tcdClassName :: Qualified (ProperName 'ClassName)
    -- | The types to which this type class instance applies
    , tcdInstanceTypes :: [Type]
    -- | Type class dependencies which must be satisfied to construct this dictionary
    , tcdDependencies :: Maybe [Constraint]
    }
    deriving (Show, Read)
```

1. What does `tcdPath` means? Why there is a `Integer` in it?
2. How to understand "type class instance"?
3. Since it is a dictionary, where is the `Map` structure?

```haskell
data DictionaryValue
  -- A dictionary which is brought into scope by a local constraint
  = LocalDictionaryValue (Qualified Ident)
  -- A dictionary which is brought into scope by an instance declaration
  | GlobalDictionaryValue (Qualified Ident)
  -- A dictionary which depends on other dictionaries
  | DependentDictionaryValue (Qualified Ident) [DictionaryValue]
  -- A subclass dictionary
  | SubclassDictionaryValue DictionaryValue (Qualified (ProperName 'ClassName)) Integer
  deriving (Show, Read, Ord, Eq)
```

Let's analyze them one by one:

* **Local constraint**: <mark>FIXME</mark> I guess it refers to `Eq a => a -> a` in which `a` is effectively a polymorphism.
* **Global constraint**: The universal fact brought by instance declaration
* **Dependent dictionary**: <mark>FIXME</mark> What does "depend" means here?
* **Subclass dictionary**: Is only a reference stored here?

-----

Comment:

No very clear. It doesn't correspond to the theory in my head very well. But I will see algorithms.

