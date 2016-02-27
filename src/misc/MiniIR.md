# MiniIR Design Draft

Two sources:

* LLVM etc.'s production-level IR
* Use it to do PPA book exercises in an iterative style


Considerations
---

* Don't use SSA (but you can compile it to SSA, certainly)
* Use `jump` instead of imperative control flow statement => While keeps instruction-centered language design
* Comments
* Better share a similar syntax to LLVM IR (highlight support, familiarity for expert etc.)
* Easy to hand code


### What can I borrow from LLVM?

* Global variable and function
* Module system and presence of linkage implication (use a keyword like `extern`)
* Supporting high-level types like structure and array
* Put pointer in a more reasonable position
* 


Notes -- LLVM IR doc
---
identifier: `%` is used for local var, `@` is used for global var; three kinds: named, unnamed(temp var), constant

LLVM programs are composed of `Module`s. Each module consists of functions, global bars, and symtable entries.

LLVM linker => name resolving & merging

linkage types:

* `private`: module-locally-visible, but as a global var
* `internal`: local symbol, like `static`
* `external`
* ...

calling conventions

* `ccc`: C calling conv, varargs, mistyping
* `fastcc`: fast calling conv (reg based), tail call opt, fixed args, exact-typing
* `coldcc`: cold calling conv. for not called much functions
*  `cc 10`: GHC conv. reg-based, tail-call, reg-pinning ...
*  `cc 11`: high performance erlang conv, similar to GHC
*  `webkit_jscc`
*  ...

Visibility style:

* `default`: visible to other module, "extern linkage", can be overriden
* `hidden`: not place in dynamic symbol table
* `protected`: in dyntable, but reference within the define module will bind locally.


thread local storage model:

* `localdynamic`: only used within current shared lib
* `initialexec`: will not be loaded dynamically
* `localexec`: used within defined


structure types: "identified" and "literal"


global var always defines a pointer to their "content"; `unnamed_addr` means that the address is not important, only the content. syntax:

```
[@G<Name> =] [Linkage] [Visibility] [DLLStorageClass] [ThreadLocal]
             [unnamed_addr] [AddrSpace] [ExternallyInitialized]
             <global | constant> <Type> [<InitializerConstant>]
             [, section "name"] [, comdat [($name)]]
             [, aligh <Alignment> ]
```


Functions:

`define`

param attr, func attr, GC name, predix, prologue, personality

a func def contains a list of basic blocks, forming the CFG for the function


each BB starts with a label, contains a list of insts, ends with a terminator inst (like return or branch).

alias: don't create new data, aliasing either a global value or a constant expr.

Comdat IR provides access to COFF or ELF object COMDAT functionality.


named metadata: a string of characters with metadata prefix

LVM IR allows metadata to be attached to instructions in the program that can convey extra information about the code to the optimizers and code generator. One example application of metadata is source-level debug information. There are two metadata primitives: strings and nodes.

param attr:

* `zeroext`: zero-extentded to the extend required by ABI of caller/callee
* `signext`
* `inreg`: emit to register
* `byval`: passed by value, a copy is made
* `inalloca`: a pointer to stack memory pointer. 
* `sret`: as a valid structure returned by function * `align`
* `noalias`:**objects** [ accessed via pointer values based on the argument or return value ] **are not also accessed** [ during the execution of the function] [ via pointer values not based on the argument or return value ]
* `nocapture`: callee does not make any copies of the pointer that outlive the callee itself
* `nest`: can be excised using trampoline instrinsics
* `returned`: argument that will be returned => tail call
* `nonnull`indicated that the parameter or return value is not NULL
* `dereferenceable`: no trapping

prologue data: arbitrary code to be inserted before the function body; can be used for hot-patching and instrumentation


func attr: ...

data layout

traget triple

any mem access must be done through a pointer specified with a addr range.

Pointer aliasing rules:

* associated with based-on value
* global var addr is associated with addr range of var's storage
* res value of an allocation inst is associated with the addr range of allocated storage
* null pointer is assoced with no addr 

a pointer value *is based on* another pointer value according to:

* first operand of `getelementptr`
* operand of `bitcast`
* `inttoptr` is based on all values contributed to the computation of pointer value
* *based on* is transitive

volatile mem access: `load`s, `store`s etc. marked with `volatile`, its number or order of execution will not changed by optimizer

mem model for conc op

atomic mem ordering constraints

fast-math flags

use-list order directives

type system => typing means optimization

`void`

function type: pointer to function, vararg, structure returing


* first class types
    + single value
        + integer
        + float
        + MMX
        + pointer type
        + vector type
        + label type
        + token type
        + metadata type
    + aggregate type
        + array
        + structure
        + opaque
+ Constants
    + Simple
        + boolean
        + integer
        + float
        + null pointer
    + Complex
        + structure
        + array
        + vector (NOTE: vector is a simple type, while array is an aggregate type)
        + zero initializer
        + metadata node


The address of global var and functions are always **implicitly valid** (link-time) constants. Can be referenced with *identifier for constant*.

`undef` can be used anywhere a constant is expected. It indicated that the program is well-defined for whatever value is used. For linear algebra and `xor`, it can be used; but the logical operator like `and` and `or` could not be optimized freely.


Poison values: it seems meaning that the undefined value can propagate in a certain style. dependency could create more poison value.





