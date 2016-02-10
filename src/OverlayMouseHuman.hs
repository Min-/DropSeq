{-#LANGUAGE OverloadedStrings#-}

{-
Project name: Overlay mouse and human data, to create plotting ready data set
Min Zhang
Date: Feb 5, 11:34pm 2016 
Version: 
README: 
-}

import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as TextIO
import qualified Data.Char as C
import Control.Applicative
import qualified Data.List as L
import qualified Data.Set as Set
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
  [input_hg19_count, input_mm9_count, output_readcount_hg19_mm9] <- take 3 <$> getArgs
  humanCellBarcodes <- map (T.splitOn " " . T.dropWhile ((==) ' ')) . T.lines <$> TextIO.readFile input_hg19_count
--  humanCellBarcodes <- map (T.splitOn " " . T.dropWhile ((==) ' ')) . T.lines <$> TextIO.readFile "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/mapped.hg19.cellbarcodes.uniqueCount.txt"
  let humanMap =  M.fromList  $ map (\[x,y] -> (y, x)) humanCellBarcodes
  mouseCellBarcodes <- map (T.splitOn " " . T.dropWhile ((==) ' ')) . T.lines <$> TextIO.readFile input_mm9_count
--  mouseCellBarcodes <- map (T.splitOn " " . T.dropWhile ((==) ' ')) . T.lines <$> TextIO.readFile "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/mapped.mm9.cellbarcodes.uniqueCount.txt"
  let mouseMap = M.fromList $ map (\[x,y] -> (y, x)) mouseCellBarcodes
  let allBarcodes = Set.toList $ Set.fromList $ (map (head . drop 1) humanCellBarcodes) ++ (map (head . drop 1) mouseCellBarcodes)
  let humanReadCount = map (\x->M.lookupDefault "0" x humanMap) allBarcodes
  let mouseReadCount = map (\x->M.lookupDefault "0" x mouseMap) allBarcodes
  let results = T.unlines $ map (T.intercalate "\t") $ L.zipWith3 (\x y z -> [x, y, z])  allBarcodes humanReadCount mouseReadCount
  TextIO.writeFile output_readcount_hg19_mm9 results
  
