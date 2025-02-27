module Test.Utilities (diffVsGoldenFile) where

import           Cardano.Prelude (ConvertText (..))

import           Control.Monad.IO.Class (MonadIO (liftIO))
import           Data.Algorithm.Diff (PolyDiff (Both), getGroupedDiff)
import           Data.Algorithm.DiffOutput (ppDiff)
import           GHC.Stack (callStack)
import           Hedgehog (MonadTest)
import           Hedgehog.Extras.Test.Base (failMessage)

-- TODO: Improve the help output by saying the difference of
-- each input.
diffVsGoldenFile
  :: (MonadIO m, MonadTest m)
  => String   -- ^ actual content
  -> FilePath -- ^ reference file
  -> m ()
diffVsGoldenFile actualContent referenceFile =
  do
    referenceLines <- map toS . lines <$> liftIO (readFile referenceFile)
    let difference = getGroupedDiff actualLines referenceLines
    case difference of
      [Both{}] -> pure ()
      _        -> failMessage callStack $ ppDiff difference
  where
    actualLines = Prelude.lines actualContent
