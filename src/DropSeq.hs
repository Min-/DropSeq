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
import qualified Data.Set as Set
import Control.Monad (fmap)
import Data.Ord (comparing)
import Data.Function (on)
import qualified Safe as S
import qualified Data.HashMap.Lazy as M
import qualified Data.Maybe as Maybe
import qualified Data.Foldable as F (all)
import Data.Traversable (sequenceA)

import qualified Data.Vector as V
import qualified Statistics.Sample.Histogram as Stats

import MyText
import MyTable
import Util
import IO
import DataTypes

{- Part I
1. Check length of reads
2. Check number of unique cell barcode
3. Check number of unique UMI
-}

testR1Path = "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.fastq"
testR2Path = "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq"



dropSeqQc = do
  inputFastq1 <- take 10000 <$> importFastq testR1Path
  let readLen = (V.fromList $ map (fromIntegral . T.length . fqseq) inputFastq1) 
  let results = (Stats.histogram 5 readLen) :: (V.Vector Double, V.Vector Int)
  print results

-- high demand on memory
ifFastqNameMatch fq1 fq2 = and $ zipWith (==) (L.sort $ map fqname fq1) (L.sort $ map fqname fq2)

-- import fq1 only seq, to check the diversity of the barcodes.
testR1SeqPath = "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.test.seq.fastq"
r1SeqPath = "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.seq.fastq"

barcodeQc inputPath = do
  allBarcodes <- map (\x->(T.take 7 $ T.drop 5 x, T.take 8 $ T.drop 12 x)) . T.lines <$> TextIO.readFile inputPath
  let results = (Set.size $ Set.fromList $ map fst allBarcodes, Set.size $ Set.fromList $ map snd allBarcodes)
  print results

sortUMI inputPath = do
  results <- map (T.splitAt 12 . T.init) . T.lines <$> TextIO.readFile inputPath
--  let output = T.unlines $ map (T.pack . show . length) $ L.reverse $ L.sortBy (comparing length) $ L.groupBy ((==) `on` snd) $ L.sortBy (comparing snd) results
  TextIO.writeFile "outputUMIsize.txt" output
