{-#LANGUAGE OverloadedStrings#-}

{-
Project name: Pipeline for analyze DropSeq data
Min Zhang
Date: Feb 5, 2016
Version: v0.1.0
README: Process raw fastq file, QC and mapping
-}

module DropSeq
where

import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as TextIO
import qualified Data.Char as C
import Control.Applicative
import qualified Data.List as L
import Control.Monad (fmap)
import Data.Ord (comparing)
import Data.Function (on)
import qualified Safe as S
import qualified Data.HashMap.Lazy as M
import qualified Data.Maybe as Maybe
import qualified Data.Foldable as F (all)
import Data.Traversable (sequenceA)
import qualified System.IO as IO
import MyText
import MyTable
import Util



{- Part I
1. Check length of reads
2. Check number of unique cell barcode
3. Check number of unique UMI
-}

main = putStrLn "hello"
