# TypeState Note

"Typestate" is the refinment of the concept "type". _Whereas the type of a date object determines the set of operations ever permitted on the object, typestate detemines the subset of these oprations which is permitted in a particular context._

Typestate tracking is a program analysis technique which enhances program reliability by detecting at compile-time syntactically legal but _semantically undefined execution sequences_.

What's more, this can also be applied in automatically insert finalization.

Typestate captures the notion of an object's being in an (in)appropriate state for the application of a particular operation. **Each type has an associated set of typestates**. An object of a given type is at each point in a program in a single one of the typestates assocated with its type.

A partial order can be defined on the typestates of a given type. Intuitively, a "higher" typestate corresponds to a larger amount of resources allocated to the object.

From one typestate to another typestate, there will be a "typestate transition" accompanying some operation. The *typestate transition* is defined by

1. A typestate precondition
2. One or more typestate postconditions

And among the various outcomes, one outcome is called "normal outcome", others called "**exceptional** outcomes"

To track typestate in a program at compile-time, we make typestate a _static invariant_ property of each variable name at each point in the program text.

To preserve the static invariance of typestates, we define a rule for resolving the typestate of variable names at points where execution paths merge, such as the beginning of a loop, the end of a conditional statement, or the entry of an exception handler. The rule of determining typestate at a merge statement S is to defined the typestate of each variable name as the greatest lower bound of the typestates of that same name on all paths merging at S.

A program execution is _typestate-correct_ iff:

1. Before the applications of each operation in the program, each operand $v_i$ has a typestate matching its typestate precondition for the operation.
2. On termination of a program, all objects declared in the program are returned to the bottom typestate.

A program text is _typestate-consistent_ iff it can be transformed by the addition of typestate-lowering coercions into a program each which can be executed typestate-correctly following any path.


Typestate tracking adds *typestate labels* to each node of the program graph. These labels associate each program variable $v_i$ with its typestate $s_i$ at that node. We shall denote these typestate labels by tuples.

---

### With calls

To archieve independent typestate checking in the presence of calls, we have _interface definition_ -- seperate modules which specify the **assumptions shared** by the calling and called modules.


For caller, it has some pre/postconditions defined on calling. While for callee, it has extractly the reverse: post-condition on `accept` and pre-condition on `return`.

Lanaguages that allow unrestricted pointer assignment do not support tracking typestate at compile-time since the mapping between symbol and object is not determined.

Except for that, the concurrency data-sharing will also interfere with typestate tracking.

