# Rust by Example Note

## Use of `fmt`

```rust
use std::fmt;

struct Structure(i32);

impl fmt::Display for Structure {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0);
    }
}
```

For any new *container* type which is *not* generic, `fmt::Display` can be implemented.

## Format String
The formatting traits and their respective argument types:

* unspecified -> `Display`
* `?` -> `Debug`
* `o` -> `Octal`
* `x` -> `LowerHex`
* `X` -> `UpperHex`
* `p` -> `Pointer`
* `b` -> `Binary`
* `e` -> `LowerExp`
* `E` -> `UpperExp`


## Capturing with Closure
```rust
fn main() {
    let color = "green";
    let print = || println!("`color`: {}", color);
    print();
    print();
    
    let mut count = 0;
    
    let mut inc = || {
        count += 1;
        println!("`count`: {}", count);
    };
    
    inc();
    inc();
    
    let movable = Box::new(3);
    
    let consume = || {
        println!("`movable`: {:?}", movable);
        drop(movable);
    };
    
    consume();
       
```

## Macro-rules

### Designators
* `block`
* `expr`
* `ident`
* `item` ?
* `pat` (pattern)
* `stmt` (statement)
* `path`
* `tt` (token tree)
* `ty` (type)

    
## Lifetimes
Always, the programmer doesn't need to explicitly annotate lifetimes, but there are cases where explicit lifetimes are required:

* Functions that return references
* Structs that hold references


## Traits
A list of "derivable" traits

* Comparision: `Eq`, `PartialEq`, `Ord`, `PartialOrd`
* Serialization: `Encodable`, `Decodable`
* `Clone`
* `Hash`
* `Rand`
* `Default`
* `Zero`
* `Debug`

## Std lib
### String
Again about `String` adn `&str`.

A `String` is stored as a vector of bytes, i.e. `Vec<u8>`, heap allocated, growable, not null terminated.

`&str` is a slice `&[u8]` that always points to a valid UTF-8 sequence, and can act as a view into a `String`, just like `&[T]` is a view into `Vec<T>`

### HashMap
Any type that implements the `Eq` and `Hash` traits can be a key in `HashMap`.

* `bool`
* `int`, `uint` etc
* `String` and `&str`

You can easily implement `Eq` and `Hash` for a custom type with just one line: `#[derive[PartialEq, Eq, Hash)]`

Consider a `HashSet` as a `HashMap` where we just care about keys. Vector, B Tree and Hashing can all be used to implement the set.

### Unsafe
There are mainly four primary sources of unsafe blocks:

1. Dereferencing raw pointers
2. Calling a function over FFI
3. Changing type through `std::cast::transmute`
4. Inline assembly (WOCAO)


