{-#LANGUAGE OverloadedStrings#-}

{-
Project name:  Sort reads from Sam file using read name and linked to cell barcodes.
Min Zhang
Date: Feb 11, 2016
Version: v0.1.0
README: input: a list of cell barcodes;
               a sam file;
        output: separated sam files

        sample file is top 1000 cell barcodes from human cells
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
import qualified System.IO as IO
import System.Environment
import DataTypes
import MyText
import MyTable
import Util
import IO

-- get cell barcodes based on readnames in the same file, and check if the cell barcode in the set of including list.
-- sam file should be mapped only, to reduce the size

main = do
  [samPath, readNameCellBarcodePath, listOfCellBarcodesPath, outputPath] <- take 4 <$> getArgs
  sam <- importSamFile samPath
  cellbarcodeDict <- makeDict readNameCellBarcodePath 
  includedCellBarcodes <- Set.fromList . T.lines <$> TextIO.readFile listOfCellBarcodesPath
  let outputSamList = map getCellBarcode $ L.groupBy ((==) `on` fst) $ L.sortBy (comparing fst) $ filterSam cellbarcodeDict includedCellBarcodes sam
--  print $ take 10 sam
--  print $ cellbarcodeDict
  mapM_ (\x-> outputSamFile (snd x) (combinePath outputPath (fst x))) outputSamList

-- Map (readname, cellbarcode, umi)
-- umi not incorperated yet TODO


-- sam readname is slightly different from fastq readname
makeDict :: FilePath -> IO (M.HashMap T.Text T.Text)
makeDict input = return . M.fromList . map (\x->(head $ T.splitOn " " $ T.tail $ head x, x!!1)) =<< smartTable input

filterSam m includeSet sam = filter (\x-> checkMembership x && checkIfMapped x) $ map mapRead sam
    where checkMembership (x, _) = Set.member x includeSet
          checkIfMapped (x, _) = x /= "na"
          mapRead read = (M.lookupDefault "na" (qname read) m, read)

getCellBarcode xs = (T.unpack $ fst $ head xs, map snd xs)

combinePath :: FilePath -> FilePath -> FilePath
combinePath outputpath cellBarcode = outputpath ++ "/" ++ cellBarcode ++ ".sam"

