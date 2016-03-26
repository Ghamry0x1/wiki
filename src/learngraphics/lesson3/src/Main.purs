module Main where

import Prelude
import Control.Monad.Eff.Console
import Graphics.Canvas (getCanvasElementById, getContext2D, withImage, Composite(..))
import Graphics.Canvas.Free
import Math hiding (log)
import Data.Maybe
import Control.Monad

main = do
    mcanvas <- getCanvasElementById "canvas"
    log "hello world"
    case mcanvas of
        Nothing -> do
            log "failed to load canvas element"
        Just canvas -> do
            withImage "resource/copycat.jpeg" $ \img -> do
                context <- getContext2D canvas
                runGraphics context $ do
                    save
                    beginPath
                    arc { x: 120.0, y: 70.0, r: 60.0, start: 0.0, end: Math.pi * 2.0 }
                    closePath
                    clip
                    drawImage img 0.0 0.0
                    restore
                    setComposite Lighter
                    setFillStyle "#FF0000"
                    beginPath
                    arc { x: 200.0, y: 140.0, r: 30.0, start: 0.0, end: Math.pi * 2.0 }
                    fill
                    setFillStyle "#0000FF"
                    beginPath
                    arc { x: 210.0, y: 150.0, r: 30.0, start: 0.0, end: Math.pi * 2.0 }
                    fill




