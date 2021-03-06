module Tests.Language
  where

import Language.Chords     (Chord (..), ChordType (..), getChordNotes)
import Language.Modulators
import Language.Notes
import Language.Shifts
import Prelude             hiding ((^))
import Test.Tasty.HUnit

testNote = Note D Flat One
testChord = Chord Major (Note C Flat One)
testNotes = [testNote, testNote, testNote]

languageTests =
  [
    -- basic constructors
    testCase "The are 7 tones"            $ length tones                        @?= 7,
    testCase "The are 2 pitches"          $ length pitches                      @?= 2,
    testCase "The are 9 octaves"          $ length octaves                      @?= 9,
    -- Shift octaves
    testCase "Shift Octave - Positive"    $ testNote ^ 5                        @?= Note D Flat Six,
    testCase "Shift Octave - Negative"    $ testNote ^ (-1)                     @?= Note D Flat Zero,
    testCase "Shift Octave - Combine"     $ testNote ^ (-1) ^ 1                 @?= testNote,
    testCase "Shift Octave - Multiple"    $ testNotes ^ 5                       @?= [Note D Flat Six, Note D Flat Six, Note D Flat Six],
    -- Modulate octaves
    testCase "Modulate Octave"            $ testNote ^= Zero                    @?= Note D Flat Zero,
    testCase "Modulate Octave - Combine"  $ (testNote ^= Zero) ^= Six           @?= Note D Flat Six,
    testCase "Modulate Octave - Multiple" $ testNotes ^= Six                    @?= [Note D Flat Six, Note D Flat Six, Note D Flat Six],
    -- Shift tones
    testCase "Shift Tone - Positive"      $ testNote # 1                        @?= Note E Flat One,
    testCase "Shift Tone - Negative"      $ testNote # (-1)                     @?= Note C Flat One,
    testCase "Shift Tone - Combine"       $ testNote # (-1) # 1                 @?= testNote,
    testCase "Shift Tone - Multiple"      $ testNotes # 1                       @?= [Note E Flat One, Note E Flat One, Note E Flat One],
    testCase "Shift Tone - Octave"        $ testNote # 7                        @?= Note D Flat Two,
    testCase "Shift Tone - Octave & Note" $ testNote # 8                        @?= Note E Flat Two,
    -- Modulate tones
    testCase "Modulate Tone"              $ testNote #= B                       @?= Note B Flat One,
    testCase "Modulate Tone - Combine"    $ testNote #= B #= A                  @?= Note A Flat One,
    testCase "Modulate Tone - Multiple"   $ testNotes #= A                      @?= [Note A Flat One, Note A Flat One, Note A Flat One],
    -- Combinding
    testCase "Combining shift and modulations" $ ((testNote #= B) ^= Zero) ^ 8  @?= Note B Flat Eight,
    -- Chords
    testCase "Chord - Major"              $ getChordNotes testChord             @?= [Note C Flat One, Note E Flat One, Note G Flat One]

  ]
