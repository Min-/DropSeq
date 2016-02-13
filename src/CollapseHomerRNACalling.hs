{-#LANGUAGE OverloadedStrings#-}

{-
Project name: Collapse Homer RNA calling files
Min Zhang
Date: Feb 12, 2016
Version: v0.1.0
README: Homer use refseq as default gtf files. Some genes have multiple RefSeq annotations. 
        Since Dropseq reads are mostly enriched in 3', collapse Refseq ID by gene names.
        hg19 has same gtf (Homer version: homer	v4.8	Code/Executables, ontologies, motifs for HOMER	http://homer.salk.edu/homer/data/software/homer.v4.8.zip; human	v5.8	Homo sapiens (human) accession and ontology information	http://homer.salk.edu/homer/data/organisms/human.v5.8.zip	data/accession/	9606,NCBI Gene
)
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
import qualified System.IO as IO
import System.Environment
import MyText
import MyTable


-- sample hg19 annotation
hg19SamplePath = "/Users/minzhang/Documents/data/P56_dropseq/DropSeq/data/analyzeRepeats.L2.hg19.txt"

-- 26457 total genes
hg19SampleDict = return . M.fromList . map (\(x,y)->(y,x)) . M.toList . M.fromList . map ((\x->(x!!7, x!!0)) . T.splitOn "\t") . tail . T.lines
   =<< TextIO.readFile hg19SamplePath

main = do
  [inputPath, outputPath] <- take 2 <$> getArgs
  includedRefSeq <- hg19SampleDict
  input <- T.lines <$> TextIO.readFile inputPath
  let header = T.concat [head input, "\t", "gene"]
  let body = tail input
  let bodyDict = M.fromList $ map (T.breakOn "\t") body -- T.breakOn doesn't delete "\t"
  let trimmedDict = M.intersectionWith (\x y-> T.concat [x, "\t", head $ T.splitOn "|" y]) bodyDict includedRefSeq
  let outputList = header : (map (\(x, y) -> T.concat [x, y]) $ M.toList trimmedDict)
  TextIO.writeFile outputPath (T.unlines outputList)
  
  
  
