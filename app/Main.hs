module Main
  where

import Language
import Notes.Default
import Synthesizer.Converters.Language (convertMusicPieceToSynthesizer)
import Synthesizer.Encoders.Wav
import Synthesizer.Structure

defaultVolume :: Amplitude
defaultVolume = 25000

musicPiece :: MusicPiece
musicPiece = MusicPiece [
    Instrument 440 defaultVolume (noteStrike 0.2 0.2 0.5 0.1) [
      NoteEvent 0   0.5 1 (C ^= Four),
      NoteEvent 0.5 0.5 1 (D ^= Four),
      NoteEvent 1   0.5 1 (E ^= Four),
      NoteEvent 1.5 0.5 1 (C ^= Four),

      NoteEvent 2   0.5 1 (C ^= Four),
      NoteEvent 2.5 0.5 1 (D ^= Four),
      NoteEvent 3   0.5 1 (E ^= Four),
      NoteEvent 3.5 0.5 1 (C ^= Four),

      NoteEvent 4   0.5 1.3 (E ^= Four),
      NoteEvent 4.5 0.5 1 (F ^= Four),
      NoteEvent 5   0.5 1.3 (G ^= Four)
    ]
  ]


mediumPrioritySignal :: SynSound
mediumPrioritySignal = convertMusicPieceToSynthesizer musicPiece

main :: IO ()
main = do
    saveSignal "medium" mediumPrioritySignal
