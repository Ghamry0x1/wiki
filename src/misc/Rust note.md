# Rust Note
> Noting during learning a safe language with checkers

## Unique Pointers
`Box<T>` for an owning(unique) pointer to `T`, use `Box::new()` to allocate space on the heap and initialise that space with the supplied value.

Owning pointera are derefenced with `*`


In Rust, you can't have a mutable pointer to immutable data.

Owning pointers can be returned from a function and continue to live on. If they are returned, their memory is not freed, i.e., there are no dangling pointers in Rust. However, once out of scope , the memory will be reclaimed.

When one pointer points at a value, any previous pointer pointing to that value can no longer be accessed. Similarly, if an owning pointer is passed to another function or stored in a field, it can no longer be accessed.

> C++'s `unique_ptr` is checked dynamically, while Rust's owning pointer is checked statically.

Method calls can automatically dereference.

Calling `Box::new()` with an existing value copy that value rather than taking reference.

## Borrowed Pointers
To create a reference to an existing value, we have to use `&`, the borrowed reference operator. And to dereference it, use `*` as well. The `&` operator does not allocate memory, and if it goes out of scope, no memory will be reclaimed correspondingly.

Mutable reference are taken with `&mut`, and it is unique.

And you can't have a mutable reference to an immutable variable.

The reference may be mutable independently of the mutableness of the variable holding the reference.

If a mutable value is borrowed, it becomes immutable for the duration of the borrow. Once the borrowed pointer goes out of scope, the value can be mutated again.

## Lifetimes

The lifetime of the reference must be shorter than the lifetime of the referenced value.

`&T` is a shorthant for `&'a T` where `a` is the current scope, that is the scope in which the type is declared.

## Ref count and raw pointers
Ref-counted pointer is from `std::rc` module.

To pass a ref-counted pointer, a `clone` method is needed.

To have mutable & ref-counted object, a `cell` for `RefCell` wrapped in an Rc is needed.

## `*T` -- unsafe pointers
Unsafe pointers are donated as `*T` and created with `&`. Specifing the type to distinct unsafe pointer from borrowed reference. They can't be dereferenced outside of an `unsafe` block, only to be passed around in regular Rust code.

Unsafe pointers are immutable by default, and can be made mutable like `*mut int`

## Data Types
In Rust, the data abstraction and behaviour abstraction are more seperated. The behaviour is defined by functions as `impl` of "traits". But "traits" can't contain data. For data, there are `struct` and `enum`.

Struct cannot be recursive. But you can use pointers to create data-level recursion.

Tuple struct is kinda mixture of `struct` and `tuple`. For example, `struct IntPoint (i32, i32)`

For `enum` in Rust, each variant can carry data, like tagged union. Many simple OO poly can be handle with Rust `enum`.

## `Cell` type

With `Cell` and `RefCell` structs, parts of immutable objects can be mutated.

Cell has `get` and `set` methods for changing the stored value, and a `new` method to initialize the cell with a value.

`RefCell` are used for types with `move` semantics. `RefCell` has `new` and `set` methods, but to get its value, `borrow` must be used, like `borrow`, `borrow_mut`, `try_borrow`, `try_borrow_mut`. 

## Destructuring

To create a reference to something in a pattern, you have to use the `ref` keyword.

## Semantics

`i32` has copy semantics while `Box<i32>` has move semantics.

Rust determines if an object has move or copy semantics by looking for **destructors**. An object has a destructor if it implements `Drop` trait.


When we get a reference to some data and need the value itself, you need to use/implement `clone` or make a manual copy.


## Mutability
In Rust, mutability is **inherited**.

## Array, Slice and Vector
Since the compiler must know the size of all objects in Rust, and it can't know the size of a slice, then we can never have a value with slice type. So, we must always have pointers to slices.


Array is fixed length, slice is dynamically sized, while the vector is heap allocated as an owning reference.

Array is a **value**, slice is like borrowed reference, and vector is like a owned pointer.


## Graphs and Arena Allocation

Since graphs can be cyclic, and ownership in Rust cannot be cyclic, so we cannot use `Box<Node>` as our pointer type. And mutabability is also a problem during the process of computation.

One solution is to use mutable raw pointers e.g. `*mut Node`, this is rather flexible but also dangerous.


Another solution: For lifetime management, use ref-counting, which solves the shared ownership problem, or you can use **arena allocation** (all nodes have the same lifetime, managed by an arena, using borrowed references `&`). For managing mutability, you can either use `RefCell`, or `UnsafeCell`.

So, this is basically a 2v2 combination:

* Lifetime: ref-counting or arena allocation
* Mutability: `RefCell` or `UnsafeCell`

> Aerna allocation is a memory management technique where a set of objects have the same lifetim and can be deallocated at the same time. An arena is an object responsible for allocating and deallocating the memory. Since large chunks of memory are allocated and deallocated at once, so ti is efficient and cache-friendly.




