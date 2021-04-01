{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Language
  where

import Prelude                         hiding ((^))
import Synthesizer.Modifiers.Envelopes (AttackLength, DecayLength,
                                        Envelope (..), ReleaseLength,
                                        SustainLevel)
import Synthesizer.Structure           (Frequency)

-- | The Tone of the Note is represented using the western-style naming scheme:
--
-- C | D | E | F | G | A | B
data Tone = C | D | E | F | G | A | B
  deriving (Show, Enum, Ord, Eq)

tones :: [Tone]
tones = [C ..]

-- | The Note is played with a Pitch
--
-- The Pitch can be Flat or Sharp
data Pitch = Flat | Sharp
  deriving (Show, Enum, Ord, Eq)

pitches :: [Pitch]
pitches = [Flat ..]

-- | The Note can be played with different Octaves. The Octaves ranges from Zero - Eight
data Octave = Zero | One | Two | Three | Four | Five | Six | Seven | Eight
  deriving (Show, Enum, Ord, Eq)

octaves :: [Octave]
octaves = [Zero ..]

-- | Note contains a Tone, Pitch and Octave
data Note = Note
  { getTone   :: Tone
  , getPitch  :: Pitch
  , getOctave :: Octave
  }
  deriving (Show, Ord, Eq)

data ChordType =
  Major
  | Minor
  | Diminished
  | MajorSeventh
  | MinorSeventh
  | DominantSeventh
  | Suspended
  | Augmented
  | Extended
  deriving (Show, Enum)

type BaseNote = Note

data Chord = Chord
  { getType     :: ChordType
  , getBaseNote :: BaseNote
  }
  deriving (Show)

type StartTime     = Double
type Duration      = Double
type AmplitudeMult = Double
-- | NoteEvent contains StartTime, the Duration of the Note, the multiplier for the Amplitude of the Note and the Note itself
data NoteEvent = NoteEvent StartTime Duration AmplitudeMult Note
               | ChordEvent StartTime Duration Chord
  deriving (Show)

noteStrike :: AttackLength -> DecayLength -> SustainLevel -> ReleaseLength -> Envelope
noteStrike = Envelope

type BaseFrequency = Frequency
type Amplitude     = Double
type BaseAmplitude = Amplitude
type NoteStrike    = Envelope
-- | Instrument contains the BaseFrequency where the Note frequencies are based on.
-- The BaseAmplitude is the volume where the Instruments plays on.
-- The NoteStrike which describes how the note amplitude is played with attack, decay, sustain and release.
-- And the list of NoteEvents which describe the played notes
data Instrument = Instrument BaseFrequency BaseAmplitude NoteStrike [NoteEvent]
  deriving (Show)

-- | The MusicPiece is a list of instruments which are played together
newtype MusicPiece = MusicPiece [Instrument]
  deriving (Show)

class ModulateOctave a b where
  (^=) :: a -> Octave -> b

instance ModulateOctave Note Note where
  (^=) note octave = note { getOctave = octave }

instance ModulateOctave [Note] [Note] where
  (^=) notes octave = map (^= octave) notes

instance ModulateOctave Tone Note where
  (^=) tone octave = Note tone Flat octave

instance ModulateOctave [Tone] [Note] where
  (^=) tones octave = map (^= octave) tones

type OctaveShift = Int

class ShiftOctave a where
  (^) :: a -> OctaveShift -> a

instance ShiftOctave Note where
  (^) note octaveShift = note { getOctave = newOctave }
    where
      newOctave = getOctaveFromInt $ getIntFromOctave (getOctave note) + octaveShift

instance ShiftOctave [Note] where
  (^) notes octaveShift = map (^ octaveShift) notes

class ModulateTone a where
  (#=) :: a -> Tone -> a

instance ModulateTone Note where
  (#=) note tone = note { getTone = tone }

instance ModulateTone [Note] where
  (#=) notes tone = map (#= tone) notes

type ToneShift = Int

class ShiftTone a where
  (#) :: a -> ToneShift -> a

instance ShiftTone Note where
  (#) note toneShift = note { getTone = newTone }
    where
      newTone = getToneFromInt $ getIntFromTone (getTone note) + toneShift

instance ShiftTone [Note] where
  (#) notes toneShift = map (# toneShift) notes

getOctaveFromInt :: Int -> Octave
getOctaveFromInt = toEnum

getIntFromOctave :: Octave -> Int
getIntFromOctave = fromEnum

getToneFromInt :: Int -> Tone
getToneFromInt = toEnum

getIntFromTone :: Tone -> Int
getIntFromTone = fromEnum
