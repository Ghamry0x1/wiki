# Rust-GC note

## The gist about design
`magic_gc_XXX` seems to be global & static.

What's diff between mark, trace and add_root?

add_root: ref-counted, which happens during object acquisition will be dynamically recorded.

mark: only used during GC period?

trace: ... it will be called recursively, it is a trait of obj. so trace is to tract, and mark on the traced stuff? Where is the mark? How the mark is implemented as a ds?

If some `T` implements `Trace`, it can be traced? What is the semantics here?

GcBox is the internal ds hold a GCed value. It has the root reqs on it. "how to understand rooting as a req?" Why the `_roots` is implemented as a `Cell`.

> `Cell` and `RefCell` are **shareable mutable container**. `Cell<T>` provides `get` and `set` methods that change the interior. `Cell<T>` is only compatible with `Copy`able value. For other type, `RefCell` with mutex has to be used.

> `RefCell`'s life time is tracked dynamically, in contrast to the static tracking of Rust's native reference types.

What is `NonZero`? `malloc_gc_allocate` would return such a wrapped mutable raw pointer to a GcBox type.

Maybe the best way to understand Rust is to draw something

```
GcBox { roots; value }
          |      | 
          v      \---> T
Heap    Cell
          |
          v 
        usize


```

The value of `roots` is accesses with `get` and `set`.

GC is another layer of container. Is is another wrapped by mysterious `NonZero` but containing a non-mutable raw pointer pointing to a `GcBox`.

When `new`, the GcBox will be unrooted first. It is something stored *internally*. The reference to `GcBox` can also be exposed to outside world with `inner` method.

While the interesting thing is to provide the `Trace` trait to `Gc`. It is like to say, anything (`T`) can be traced can be GCed as long as we can trace the `Gc<T>`. The methods are mostly delegated to the inner `GcBox`.

We will also implement `Clone` and `Deref` to `Gc<T>`.

> `Clone` trait is for types that cannot be "implicitly copied". When the type is not so simple, and it is allocated and has finalizers (i.e. they do not contain owned boxed or implement `Drop`), it can't be implicitly copied.

`Deref`'s semantic is to take a value from a pointer-like stuff.

`GcCell` is mutable. It doesn't use `T` directly, but wrapped with another layer of `RefCell`.

`borrow` lasts until the returned ref `Ref` exits its scope. `borrow_mut` is mutable and unique. `Ref` wraps a borrowed reference to a value in a `RefCell` box. `borrow_state` can be used to do a inspection. If it already borrowed mutably, it is already rooted somewhere else so we don't have to trace again. If not, we will trace its internal value.

`GcCellRefMut` acts as a RAII guard. It provides access to inner value while ensuring that the data isn't collected incorrectly. It has both a `ref` and a `box`. So why two sources?

For `Deref` and `DerefMut`, the ref one is used.

For Drop, both the box and the ref is unrooted.

A remarkable point is that it is explicitly notated a lifetime `'a` why?


`RefMut` is a wrapper type for a mutably borrowed value from a `RefCell<T>`

```
GcCellRefMut { _box; _ref }
                 |    |
             /--/      \---\
            |               |
            v               v
          GcBox           RefMut
            |               |
            v               /
          RefCell          /
            |             /
            v            /
           value <------/
```


Here is something to clarify: `mut`, `ref`, and `cell`.

For the native `mut` used by Rust compiler, it is a static checking mark to ensure that the mutability is declared. So it is easier to check other operations involving ownership.

While for `ref`, it is mostly a library function, providing some more flexible `&` semantics. It is from `core::cell`. `cell` is a data structure. Sharing is implemented by `Rc`, while mutable sharing is provided by `RefCell`. I don't know clearly its relationship with the more builtin stuff however.

## Implementation





