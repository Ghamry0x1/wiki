`PSCi`
---

`supportModule` prepare the evaluator environment and name the module `S` as support module `$PSCI.Support`.

```haskell
module S where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Console
import Control.Monad.Eff.Unsafe

class Eval a where
  eval :: a -> Eff (console :: CONSOLE) Unit

instance evalShow :: (Show a) => Eval a where
  eval = print

instance evalEff :: (Eval a) => Eval (Eff eff a) where
  eval x = unsafeInterleaveEff x >>= eval
```

The interpreter monad:

```haskell
newtype PSCI a = PSCI { runPSCI :: InputT (StateT PSCiState IO) a }
               deriving (Functor, Applicative, Monad)

-- From psci/Types.hs
data PSCiState = PSCiState
  { psciImportedModules     :: [ImportedModule]
  , _psciLoadedModules      :: Map FilePath [P.Module]
  , psciForeignFiles        :: Map P.ModuleName FilePath
  , psciLetBindings         :: [P.Declaration]
  , psciNodeFlags           :: [String]
  }
```



And next, some very dirty work

* Find `node` executable
* Load history
* Load modules

#### `ImportedModule`

```haskell
-- From psci/Types.hs
--
-- | All of the data that is contained by an ImportDeclaration in the AST.
-- That is:
--
-- * A module name, the name of the module which is being imported
-- * An ImportDeclarationType which specifies whether there is an explicit
--   import list, a hiding list, or neither.
-- * If the module is imported qualified, its qualified name in the importing
--   module. Otherwise, Nothing.

type ImportedModule = (P.ModuleName, P.ImportDeclarationType, Maybe P.ModuleName)
```

And some user-friendly stuff till...

`psciIO`: life `IO` operation into `PSCI` monad.

`createTemporaryModuleXXX`: The volatile is like a container with type of `Module`. FIXME: How is that sensible?

* `runMake`: Approximately from `Make a` to `IO a`
* `makeIO`: Approximately from `IO a` to `Make a`

`make :: PSCiState -> [P.Module] -> P.Make P.Environment` this basically turns configuration into runnable environment.

The evaluator: `handleExpression :: P.Expr -> PSCI ()`

Take declarations and updates the environment: `handleDecls :: [P.Declaration] -> PSCI ()`

Dynamic import: `handleImport :: ImportedModule -> PSCI ()`

Typing & Kinding: `handleTypeOf :: P.Expr -> PSCI ()`, `handleKindOf :: P.Type -> PSCI ()`

And after that, the rest functions are mostly interactive-specific utilities.

-----

Comments:

This module can be pretty useful. You can load a interpreter and run some PureScript code anytime your want.

For the compile-time interpreting, the key is to keep the compiler-state and `PSCiState` *synced*. And sane preparation of environment can also be a problem.

For the PSCi-on-the-web, only difference is "console" becomes "socket". And by using UNIX redirect techniques, we can write a third-party web server doing process invocation directly. It can be in PureScript as well! But if you are going to sell such thing to community, it has to be easy to deploy as well!


