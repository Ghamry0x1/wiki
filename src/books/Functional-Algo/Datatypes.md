# Concrete data types

## Lists
```haskell
insert :: (Ord a) => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys)
| (x > y) = y:(insert x ys)| otherwise = x:y:ys
```

If item is inserted at the end of the list, this list will have to be replicated.

We can share one cell by this.

```haskell
insert x l@(y:ys) | (x > y)   = y:(insert x ys)
                  | otherwise = x:l
```

A function that doesn't produce partial results (that is, it traverses the entire list before producing its result) is called a *tail-strict* function.

### Deforestation with lists: Avoid intermediate results.

For example, instead of `(map (+2) . map (+3))`, we transformed it into `map (+5)`.

> Burstall-Darlington transformation

### Removing appends (`++`)

```
[] ++ x = x
(x : y) ++ z = x : (y ++ z)
(x ++ y) ++ z = x ++ (y ++ z)
```

The aim of transformation is to eliminate `++` from form `(f x ...) ++ y`by making it equivalent to `f' x ... y`. Here, `f'` is also called *generalization* of `f`.

Example:

```haskell
reverse [] = []
reverse (x : xs) = (reverse xs) ++ (x:[])
```

is optimized into:

```haskell
reverse' [] y = y
reverse' (x : xs) y = reverse' xs (x : y)
```

Both space and time have been reduce from $O(n^2)$ to $O(n)$.

### Reduce the passes
Example:

```
average xs = sum xs / fromInt (length xs)
```

we can use *tupling* method to make two traversals into one.

```haskell
average' xs = s / fromInt n
    where
        (s, n)    = av xs
        av []     = (0, 0)
        av (x:xs) = (x + s0, n0 + 1)
            where
                (s0, n0) = av xs
```

However, this solution needs extra space and might cause space leak.

We can parameterize the results:

```haskell
average'' xs = av' xs 0 0
    where
        av' []       s n = s / fromInt n
        av' (x : xs) s n = av' xs (x + s) (n + 1)
```

## Trees
> In addition to lists and trees, the deforestation algorithm can deal with any other ADT.

The intra-traversal dependency:

```haskell
comp'' _ Empty = (Empty, 0)
comp'' x (NodeBT v lf rt) 
{-  = ( perc x (NodeBT v lf rt)
      , tsum (NodeBT v lf rt))
    = ( NodeBT (fromInt v / fromInt x)
               (perc x lf) (perc x rt)
      , v + tsum lf + tsum rt)
    = ( NodeBT (fromInt v / fromInt x)
               p1 p2
      , v + s1 + s2)
      where
        (p1, s1) = (perc x lf, tsum lf)
        (p2, s2) = (perc x rt, tsum rt) -}
    = ( NodeBT (fromInt v / fromInt x)
               p1 p2
      , v + s1 + s2)
      where
        (p1, s1) = comp'' x lf
        (p2, s2) = comp'' x rt

comp' t = t'
    where
        (t', x) = comp'' x t
```

**Comment:** the `x` in `comp'` looks a bit weird. It seems to be lazy -- i.e., the `fromInt x` used in `comp''` are not evaluated until the outmost `comp''` returns and the `x` on the left hand side is determined. And when it is determined, the other references to `x` can be resolved as WHNF.

### Removing appends
```haskell
inorder Empty            = []
inorder (NodeBT a lf rt) = inorder lf ++ [a] ++ inorder rt
```

can be optimized into

```haskell
inorder' t = inorder'' t []
    where
        inorder'' Empty z = z
        inorder'' (NodeBT a lf rt) z =
            inorder'' lf (a:(inorder'' rt z))
```

## Arrays
```haskell
ixmap b f a = array b [ (k, a ! f k) | k <- range b ]

-- Matrix
row :: (Ix a, Ix b) => a -> Array (a, b) c -> Array b c
row i m = ixmap (l', u') (\j -> (i, j)) m
    where ((l, l'), (u, u')) = bounds m
```

## Exercises
### 4.1

Compare efficiency implication of `foldl` and `foldr`.

First, the implementation of these functions are like:

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f a []     = a
foldl f a (x:xs) = foldl f (f a x) xs

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f a []     = a
foldr f a (x:xs) = f x (foldr f a xs)
```

Although `foldl` is tail-recursive, but in a lazy language like Haskell, the `foldl` will never evaluate the `f a x` but left it as a thunk. Then, a tower of thunks is built

    f (f (f a x) x') x'' ....

until the result of `foldl` can be used.

However, for `foldr`, `f x` is put at the head position. Think about `map f xs = foldr (\x ys -> f x : ys) [] xs`, the `f x (foldr f a xs)` is `g x : (foldr g a xs)`. And the head, `g x` will be evaluated instantly as needed. And till the last `foldr` is resolved, the space needed for this expression is constant.

### 4.2

    comp f g l = [ f (g x) | x <- l, x > 10 ]

### 4.3
#### (a)
```haskell
split' x []     = ([], [])
split' x (a:as) = if a <= x
                    then (a : xs, ys)
                    else (xs, a : ys)
    where
        (xs, ys) = split' x l

```

#### (b)
```haskell
split'' x [] ret          = ret
split'' x (a:as) (xs, ys) =
    if a <= x
        then split'' x as (a : xs, ys)
        else split'' x as (xs, a : ys)
```


### 4.4
Ignored

### 4.5
```haskell
isEqual :: BTree a -> Btree a -> Bool
isEqual Empty Empty = True
isEqual (BTNode _ l r) (BTNode _ l' r') =
    isEqual l l' && isEqual r r'
isEqual _ _ = False
```

The `isEqual` will be recursively expanded in the second clause, till the leave node, which is a length propositional to the height of the tree.

### 4.6 and follows
Ingored
