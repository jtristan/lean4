/-
Copyright (c) 2024 Amazon.com, Inc. or its affiliates. All Rights Reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jean-Baptiste Tristan
-/
prelude
import Init.Data.Range

open Std

namespace Char.UnicodeSkipList

/-
The following data structure is used to represent the set of characters
that have some property. The data structure is precomputed using the
tool in script/unicode.

We use a variant of the skip list data structure that takes advantage
of the distribution of character properties for the common properties of
interest. Considering the sequence of codepoints that satisfy a given
property, they tend to appear is small ranges that are clustered. These
clusters are separated from each others by large ranges of codepoint that
do not satisfy the property. We refer to such clusters as runs.

The data structure takes advantage of this by representing the set
using an array of 32 bits integers (the outter array that allows to skip)
and an array of 8 bits integers. The integers of the outter array
contains enough information to let us locate in which run a codepoint
belong, and we call it `runs`. The bytes of the inner array, which we call
`offsets` record the length of the ranges. Large ranges of codepoints
that do not satisfy a property appear in the offsets as 0.

A key property of the inner array is that the index of range tells us
whether the property holds for that range or not. Therefore, to find
whether a character has a property, we first use the `runs` array
to locate where to search in the `offsets` array. We can then locate the
character in the offsets array to determine the parity of its position.

The 32 bit integers in the outter array contain encode the following
information. The 11 most significants bits are an index into the inner
array, pointing to the start of a run. The 21 least significant bits
point to the codepoint one passed the run.

-/

structure UnicodePropertyTable where
  runs : Array UInt32
  offsets : Array UInt8
  deriving Repr, Inhabited, Nonempty

/-
Search a character in the outter `runs` array and return a range in
`offsets` where the character will be found and the length of the run.
-/
def searchRuns (table : UnicodePropertyTable) (c : Char) : Nat × Range := Id.run do
  let codepoint := c.toNat
  let mut i := 0
  for run in table.runs do
    let prefixSum := run.toNat % 2^21
    if codepoint < prefixSum then
      break
    i := i + 1
  let idx := i
  let codepointStart := if idx = 0 then 0 else table.runs[idx - 1]!.toNat % 2^21
  let rangeStart := table.runs[idx]!.toNat / 2^21
  let rangeStop := if idx + 1 = table.runs.size then table.offsets.size else (table.runs.get! (idx + 1)).toNat / 2^21
  let range : Range := [rangeStart:rangeStop]
  return (codepointStart, range)

/-
Search a character in the inner `offsets` array by keeping track
of how many characters of the prefix sum of ranges' length and
use the index parity to decide if the character has the property.
-/
def searchOffsets (table : UnicodePropertyTable) (c : Char) (range : Range) (pfs : Nat) : Bool := Id.run do
  let codepoint := c.toNat
  let mut i := 0
  let mut prefixSum := pfs
  for j in range do
    if codepoint < prefixSum + (table.offsets.get! j).toNat then
      i := j
      break
    else
      prefixSum := prefixSum + (table.offsets.get! j).toNat
  return i % 2 = 1

def search (table : UnicodePropertyTable) (c : Char) : Bool :=
  let (pfs,range) := searchRuns table c
  searchOffsets table c range pfs

end Char.UnicodeSkipList
