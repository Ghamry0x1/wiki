# Python Source -- PVM

## Frame

* Linked list of `PyFrameObject` -- x86 stack frame
* `f_back` function -- `esp`, `ebp` 
Namespace: mapping from name (string) to object (pointer)

* `f_buitins`
* `f_globals`
* `f_locals` 
Actually, we already know the needed size of stack size when compiling `PyCodeObject`, as `f_stacksize`.

Another thing is that, the use of closure will also cause extra space in the `PyFrameObject`.

We can get access to the frame object at runtime through Python interface, which is basically a hack based on the exception mechanism of VM.

## Scope
One `.py` file is one *module*, which is the highest level of scope.

How to understand assignment in Python: Binding an object to name in specified scope. It can also be viewed as a "constraint".

Object also has its own namespace, in which the method names and attribute names are defined.

### LGB rule
Priority in descending order:

* L: function / method - local
* G: module - global scope
* B: builtin scope

Considering closure, we have:

### LEGB

* E: Enclosing function

### `global`
Force use the name in global scope

## Runtime Framework
* Environment Initialization: `PyEval_EvalFrameEx`
    + `PyFrameOjbect`'s information
    + `PyCodeOjbect`'s information
    + `f_stacktop`
    + main thread
* Loop
    * `why`: exception



Thread information: `PyThreadState`. Imported modules are shared across the threads. Sync -- GIL, or Global Interpreter Lock.

Process abstraction: `PyInterpreterState`

The interaction between frame and thread: 

When the evaluation starts, we will use `PyThreadState_GET()` to get current active thread object, then set its frame. When we need to create new `PyFrameObject` object, we will retrieve old frame from thread state, create new execution environment, link the new frame to old one.

![](pvm.pdf)




