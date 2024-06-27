import Unicode.Unicode

open System IO FilePath Process FS Std

def unicodeUrl : String := "https://www.unicode.org/Public/UCD/latest/ucd/"
def unicodeDatasets : List String := ["UnicodeData.txt"]

def download  (url : String) (file : FilePath) : IO Output := do
  if (¬ (← file.pathExists)) then
    output { cmd := "curl", args := #["-s", "-S", "-f", "-o", file.toString, "-L", url] }
  else pure { exitCode := 0, stdout := "", stderr := "" }

def mkGeneralCategory (s : String) : Except String GeneralCategory := do
  if s = "Lu" then pure <| GeneralCategory.Letter Letter.Lu
  else if s = "Ll" then pure <| .Letter .Ll
  else if s = "Lt" then pure <| .Letter .Lt
  else if s = "Lm" then pure <| .Letter .Lm
  else if s = "Lo" then pure <| .Letter .Lo
  else if s = "Mn" then pure <| .Mark .Mn
  else if s = "Mc" then pure <| .Mark .Mc
  else if s = "Me" then pure <| .Mark .Me
  else if s = "Nd" then pure <| .Number .Nd
  else if s = "Nl" then pure <| .Number .Nl
  else if s = "No" then pure <| .Number .No
  else if s = "Pc" then pure <| .Punctuation .Pc
  else if s = "Pd" then pure <| .Punctuation .Pd
  else if s = "Ps" then pure <| .Punctuation .Ps
  else if s = "Pe" then pure <| .Punctuation .Pe
  else if s = "Pi" then pure <| .Punctuation .Pi
  else if s = "Pf" then pure <| .Punctuation .Pf
  else if s = "Po" then pure <| .Punctuation .Po
  else if s = "Sm" then pure <| .Symbol .Sm
  else if s = "Sc" then pure <| .Symbol .Sc
  else if s = "Sk" then pure <| .Symbol .Sk
  else if s = "So" then pure <| .Symbol .So
  else if s = "Zs" then pure <| .Separator .Zs
  else if s = "Zl" then pure <| .Separator .Zl
  else if s = "Zp" then pure <| .Separator .Zp
  else if s = "Cc" then pure <| .Other .Cc
  else if s = "Cf" then pure <| .Other .Cf
  else if s = "Cs" then pure <| .Other .Cs
  else if s = "Co" then pure <| .Other .Co
  else if s = "Cn" then pure <| .Other .Cn
  else throw s!"Unknown General Category: {s}"

def loadUnicodeData (file : FilePath) : ExceptT String IO (List UnicodeData) := do
  let content : String ← readFile file
  let content : List String := content.splitOn "\n"
  let mut data := []
  for line in content do
    if line ≠ "" then -- UnicodeData.txt ends with an empty line
      let line : List String := line.splitOn ";"
      let codepoint : String := line.get! 0
      let gc : GeneralCategory ← mkGeneralCategory (line.get! 2)
      match codepoint.toNatHex? with
      | none => throw "Conversion of codepoint failed"
      | some c => data := { codepointRaw := codepoint , codepoint := c, gc := gc } :: data
  return data.reverse
