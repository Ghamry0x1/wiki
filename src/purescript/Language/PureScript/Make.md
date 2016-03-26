`Make`
----

In this module, we will understand the compilation pipeline of PureScript. The `Make` can indicate that, it is not simply a intra-module transformation, but a whole process including:

* Import/Export
* Dependency Track and Timestamp
* Read/Write source/generated from filesystem
* Monitoring the progress

> If timestamps have not changed, the externs file can be used to provide the module's types without having to typecheck the module again.

1. `sortModules`: Analyze dependency and sort modules (from `Language/PureScript/ModuleDependencies.hs`)
2. `barriers :: [(ModuleName, (MVar (Maybe (MultipleErrors, ExternsFile)), MVar (Maybe MultipleErrors)))]`: Split the build into concurrent stages.
3. For every module in `sorted`
    + Fork a new thread and check if dependency exists
    + `buildModule`
        + Wait on dependencies to be built and return the externs
        + Decide whether to rebuild based on timestamp of dependencies and the module to build
        + If need, then `rebuild`
            - Load the externs of deps to `Environment`
            - `lint`
            - `desugar`
                * Desugar object literals with wildcards into lambdas
                * Desugar operator sections
                * Desugar do-notation using the @Prelude.Monad@ type class
                * Desugar top-level case declarations into explicit case expressions
                * Desugar type declarations into value declarations with explicit type annotations
                * Qualify any unqualified names and types
                * Rebracket user-defined binary operators
                * Introduce type synonyms for type class dictionaries
                * Group mutually recursive value and data declarations into binding groups.
            - `typeCheckModule`
            - `checkExhausiveModule`
            - `createBindingGroups`
            - `moduleToCoreFn`
            - `renameInModules`
            - `moduleToExternsFile`
            - `codegen` the renamed module
        + If not, then `markComplete`
4. Collect errors from the second `MVar` in barrier
5. Bundle up all the externs and return them as an `Environment`

Now, let try to understand the `MakeActions m`:

> Actions that require implementations when running in "make" mode. This type exists to make two things abstract:

> * The particular backend being used (Javascript, C++11, etc.)
* The details of how files are read/written etc.

It means that the I/O and `codegen` are abstracted here.

----

Comments:

What we can learn from this module is the module organization of PureScript and the compilation pipeline. 


