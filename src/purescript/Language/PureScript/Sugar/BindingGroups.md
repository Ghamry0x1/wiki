`BindingGroups`
----

Let's first observe:

```haskell
-- Data recursive
data Tree a = Tree (Edge a) a (Edge a)
data Edge a = Edge Int (Tree a) -- Int is length of edge to the next tree node

-- Value recursive (top-level)
f x = g (x - 1) + g (x - 2)
g y = f (y - 1) * f (y - 2)

-- Value recursive (local)
h x = let
        f x = g (x - 1) + g (x - 2)
        g y = f (y - 1) * f (y - 2)
      in
        f x

```

Practically, without `f`, `g` can' t be well-defined and vice versa.

By grouping, we need to understand some theoretical implications:

* How will *dependency analysis* be done?
* How is *type-safety* guaranteed?
* How does it affect the *compiled code*?

First, the *possibly* mutual recursive declarations introduced by local `let` expression are handled by `handleDecls`.

Second, all top-level declarations are sent to `handleDecls`. And in that part, `dataDecls` and `values` are processed with `dataBindingGroupDecls` and `bindingGroupDecls`.

I guess the `Vert` in `dataVerts` means vertices, i.e., a `data` vertex is triple $\langle d, type(d), refered(d)\rangle$. The third one is used to construct edges.

Then, `stronglyConnComp :: Ord key => [(node, key, [key])] -> [SCC node]` groups the vertices into strongly-connected components.


Another category of algorithms is *collapsing*: `collapseBindingGroups`. This is used in:

    ./src/Language/PureScript/Make.hs:
        regrouped <- createBindingGroups moduleName . collapseBindingGroups $ elaborated


Only one possibility comes to my mind: Some declarations are introduced after grouping, so regrouping is necessary.

------

Comment:

It is just tip of the iceberg. The code-gen process after grouping can be more difficult. See [https://en.wikipedia.org/wiki/Recursive_data_type#Theory](https://en.wikipedia.org/wiki/Recursive_data_type#Theory)
