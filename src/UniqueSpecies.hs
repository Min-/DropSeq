{-#LANGUAGE OverloadedStrings#-}

{-
Project name: Get unqiue cell barcode that either mapped by hg19, mm9 or both
Min Zhang
Date: Feb 5, 2016
Version: v0.1.0
README: 
-}

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
import System.Environment
import MyText
import MyTable
import Util

main = do
  [input_hg19, input_mm9, name_cellbarcode, output_hg19, output_mm9] <- take 5 <$> getArgs
--  hg19mapped <- T.lines <$> TextIO.readFile "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/uniquemapped.hg19.readnames.txt"
--  mm9mapped <- T.lines <$> TextIO.readFile "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/uniquemapped.mm9.readnames.txt"
  hg19mapped <- T.lines <$> TextIO.readFile input_hg19
  mm9mapped <- T.lines <$> TextIO.readFile input_mm9
  allReads <- M.fromList . map ((\[x,y]->(T.tail $ head $ T.splitOn " " x,y)) . T.splitOn "\t") . T.lines <$> TextIO.readFile name_cellbarcode  
  let hg19mappedbarcodes = map (\x->M.lookupDefault "na" x allReads) hg19mapped
  let mm9mappedbarcodes = map (\x->M.lookupDefault "na" x allReads) mm9mapped
--  TextIO.writeFile "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/mapped.hg19.cellbarcodes.txt" (T.unlines hg19mappedbarcodes)
--  TextIO.writeFile "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/mapped.mm9.cellbarcodes.txt" (T.unlines mm9mappedbarcodes)
  TextIO.writeFile output_hg19 (T.unlines hg19mappedbarcodes)
  TextIO.writeFile output_mm9 (T.unlines mm9mappedbarcodes)


