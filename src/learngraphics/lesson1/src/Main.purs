module Main where

import Prelude
import Control.Monad.Eff.Console
import Graphics.Canvas (getCanvasElementById, getContext2D)
import Graphics.Canvas.Free
import Math hiding (log)
import Data.Maybe 

main = do
    mcanvas <- getCanvasElementById "canvas"
    case mcanvas of
        Nothing -> do
            log "failed to load canvas element"
        Just canvas -> do
            context <- getContext2D canvas

            runGraphics context $ do
                setFillStyle "#00FFFF"
                rect { x: 0.0, y: 0.0, w: 40.0, h: 60.0 }
                fill

                setStrokeStyle "#000000"
                at 100.0 100.0 $ triangle

                setFillStyle "#FFFF00"
                at 150.0 150.0 $ circle 50.0



triangle = do
    beginPath
    moveTo 0.0 (-100.0)
    lineTo 75.0 100.0
    lineTo (-75.0) 100.0
    closePath
    stroke

circle size = do
  beginPath
  arc { x: 0.0, y: 0.0, r: size, start: 0.0, end: Math.pi * 2.0 }
  fill

at x y gfx = do
  save
  translate x y
  gfx
  restore
