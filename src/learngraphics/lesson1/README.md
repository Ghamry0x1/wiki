Lesson 1 - Basic 2D Shapes
---

In this lesson, we are going to understand the basic 2D shape as graphic element, as well as how to draw them with HTML5 and PureScript.

## Why basic shapes?

Well, there are two reasons: First, when we are still children learning how to draw, drawing the basic shapes is first step; Second, it requires little math knowledge, but still an excellent example of how to apply math in engineering task.

We are going to talk about 3 basic shapes:

* Rectangle
* Triangle
* Circle

## Theory

In 2d world, we can use a vector from a given point (reference point) to represent the position of any point. But for simplicity, we define *coordinate* to be a tuple of real numbers, and assume the origin to be $(0, 0)$, so a point can be represented in form of $(x, y)$. Note that the vector form is equivalent to the coordinate form.

So next is line, or more exactly, segment. One segment has two endpoints. And **reversely**, any two different points can detemine a segment. $$Segment \leftrightarrow (Point, Point)$$

Next is rectangle. One rectangle has four segments, or four endpoints. And **reversely**, any four points or four segments, when satisfying some properties, can make up a rectangle. For example, given different points $p1, p2, p3, p4$, consider vectors formed $v_{12}, v_{23},v_{34},v_{41}$. Apparently, only when $v_{12} \cdot v_{41} = v_{12} \cdot v_{23} = 0$, they form a rectangle.

or, $(x_2 - x_1)(x_4 - x_1) + (y_2 - y_1)(y_4 - y_1) = (x_2 - x_1)(x_4 - x_1) + (x_3 - x_2)(y_3 - y_2) = 0$

Next is triangle. One triangle defines three segments or three points.So **reversely**, any three different points can make up one triangle.

Next is circle. Circle should be defined in term of "set of points". That is different from segments. The set can be infinitely large due to the real number's property. But definition can be concise. Thus, circle is $\{(x, y) \,\vert\, (x - x_0)^2 + (y - y_0)^2 = r^2 \}$. So there comes another more succinct representation by its center $(x_0, y_0)$ and radius $r$.


## Practice
### PureScript?
Yes, we will not use JavaScript. PureScript is more "pure" as a functional language which can be compiled to JavaScript. PS's syntax is cleaner which can make us focus on the problem; PS's functional features are powerful which can solve problems in a amazingly simple way; PS's type system is safer so we don't have to waste time debugging non-sense.

## Let's hack
Phil Freeman, the author of PureScript, wrote a book about it. But if it is too lengthy, you just need to follow me.

First, we need to get `npm`. For OS X, it is simply `brew install npm`. After that, we can install the compiler et cetera by `npm install -g bower purescript pulp`.

Then we can enter the code directory `lesson1` and `pulp dep install` and wait for it to finish. After that, we will compile the source to js, with `pulp browserify -O -t index.js`. Then, open the `index.html` and see the amazement.

That is the typical workflow.

Let's see what is inside `src/Main.purs`.

```haskell
module Main where

import Prelude
import Control.Monad.Eff.Console
import Graphics.Canvas (getCanvasElementById, getContext2D)
import Graphics.Canvas.Free
import Math hiding (log)
import Data.Maybe 

main = do
    mcanvas <- getCanvasElementById "canvas" -- Maybe Canvas
    case mcanvas of
        Nothing -> log "failed to load canvas element" -- console.log
        Just canvas -> do
            context <- getContext2D canvas -- get the context

            runGraphics context $ do -- draw within the context
                setFillStyle "#00FFFF" -- set the fill-in color
                rect { x: 0.0, y: 0.0, w: 40.0, h: 60.0 } -- put a rectangle on screen
                fill -- fill it

                setStrokeStyle "#000000" -- set the stroke, or line color
                at 100.0 100.0 $ triangle -- draw a triangle at certain place

                setFillStyle "#FFFF00" -- change color
                at 150.0 150.0 $ circle 50.0 -- draw circle



triangle = do
    beginPath -- begin track a path of segments
    moveTo 0.0 (-100.0) -- start point
    lineTo 75.0 100.0 -- first segment
    lineTo (-75.0) 100.0 -- second segment
    closePath -- close up
    stroke -- draw the path

circle size = do
  beginPath
  arc { x: 0.0, y: 0.0, r: size, start: 0.0, end: Math.pi * 2.0 }
  -- start and end are in unit radian
  fill

at x y gfx = do
  save -- save current context (including position of pen point)
  translate x y -- moving
  gfx -- do something
  restore -- restore the context
```

The details of code is self-documented. But we need to cover some high-level points here, they reflect the programming model of 2D drawing with `canvas` API.

### Canvas Model
Yes, image a canvas. You have a pen. You also have some models, like rectangles. But to draw arbitrary polygon, you have to draw line by line, *without lifting the pen*. And you can change color in the color box.


And two important things: "fill" and "stroke". Fill draws a solid shape by filling the path's content area. Stroke draws the shape by stroking its outline.

And due to the power of computer, we can save and restore contexts! It is due to the fact that, we just want to do something *temporally*.





