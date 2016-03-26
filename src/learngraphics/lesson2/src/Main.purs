module Main where

import Prelude
import Control.Monad.Eff.Console
import DOM.Timer
import Graphics.Canvas (getCanvasElementById, getContext2D)
import Graphics.Canvas.Free
import Math hiding (log)
import Data.Maybe
import Control.Monad
import Data.Int (toNumber)

main = do
    mcanvas <- getCanvasElementById "canvas"
    case mcanvas of
        Nothing -> do
            log "failed to load canvas element"
        Just canvas -> do
            let s0 = 400
            let r = 100.0
            repeatEvery 100 0 $ \s -> do
                context <- getContext2D canvas
                runGraphics context $ do
                    clear
                    setFillStyle "#000000"
                    let s' = s `mod` s0
                    let x = if s' * 2 > s0 then s0 - s' else s'
                    let theta = (toNumber s' / toNumber s0) * Math.pi
                    let r' = r - ((toNumber s') / 10.0)
                    let lineX = (toNumber x) - (Math.cos theta) * r'
                    let lineY = (Math.sin theta) * r' + 10.0
                    line (toNumber x) 10.0 lineX lineY
                    let size' = (toNumber s') / 50.0
                    at (toNumber x) 10.0 $ circle (2.0 + size')

repeatEvery t s f = do
    _ <- timeout t $ do
        f s
        repeatEvery t (s + 5) f
    return unit

at x y gfx = do
  save
  translate x y
  gfx
  restore

circle size = do
  beginPath
  arc { x: 0.0, y: 0.0, r: size, start: 0.0, end: Math.pi * 2.0 }
  fill

clear = do
    setFillStyle "#FFFFFF"
    rect {x: 0.0, y: 0.0, h: 400.0, w: 400.0 }
    fill

line x0 y0 x1 y1 = do
    beginPath
    moveTo x0 y0
    lineTo x1 y1
    stroke
