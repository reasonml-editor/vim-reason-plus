" Vim syntax file
" Language:     Reason (Forked from Rust)
" Maintainer:   (Jordan - for Reason changes) Patrick Walton <pcwalton@mozilla.com>
" Maintainer:   Ben Blum <bblum@cs.cmu.edu>
" Maintainer:   Chris Morgan <me@chrismorgan.info>
" Last Change:  January 29, 2015
" Portions Copyright (c) 2015-present, Facebook, Inc. All rights reserved.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Syntax definitions {{{1
" Basic keywords {{{2
syn keyword   rustConditional switch match if else for in when fun
syn keyword   rustOperator    as

syn match     rustAssert      "\<assert\(\w\)*!" contained
syn match     rustPanic       "\<panic\(\w\)*!" contained
syn keyword   rustKeyword     box nextgroup=rustBoxPlacement skipwhite skipempty
syn keyword   rustKeyword     extern nextgroup=rustExternCrate,rustObsoleteExternMod skipwhite skipempty
" syn keyword   rustKeyword     fun nextgroup=rustFuncName skipwhite skipempty
syn keyword   rustKeyword     unsafe where while lazy
syn keyword   rustStorage     and class constraint exception external include inherit let method module nonrec open private rec type val with mutable
" FIXME: Scoped impl's name is also fallen in this category
" syn keyword   rustStorageIdent   let and module type nextgroup=rustIdentifier skipwhite skipempty

syn keyword   rustExternCrate crate contained nextgroup=rustIdentifier,rustExternCrateString skipwhite skipempty
" This is to get the `bar` part of `extern crate "foo" as bar;` highlighting.
syn match   rustExternCrateString /".*"\_s*as/ contained nextgroup=rustIdentifier skipwhite transparent skipempty contains=rustString,rustOperator
syn keyword   rustObsoleteExternMod mod contained nextgroup=rustIdentifier skipwhite skipempty

syn match     rustIdentifier  contains=rustIdentifierPrime "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
syn match     rustFuncName    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
"
syn match labelArgument "\(\l\|_\)\(\w\|'\)*::\(?\)\?"lc=0   "Allows any space between label name and ::
syn match labelArgumentPunned "::\(?\)\?\(\l\|_\)\(\w\|'\)*"lc=0   "Allows any space between label name and ::

syn match    rustEnumVariant  "\<\u\(\w\|'\)*\>[^\.]"me=e-1
" Polymorphic variants
syn match    rustEnumVariant  "`\w\(\w\|'\)*\>"

syn match    rustModPath  "\<\u\w*\."


syn region    rustBoxPlacement matchgroup=rustBoxPlacementParens start="(" end=")" contains=TOP contained
" Ideally we'd have syntax rules set up to match arbitrary expressions. Since
" we don't, we'll just define temporary contained rules to handle balancing
" delimiters.
syn region    rustBoxPlacementBalance start="(" end=")" containedin=rustBoxPlacement transparent
syn region    rustBoxPlacementBalance start="\[" end="\]" containedin=rustBoxPlacement transparent
" {} are handled by rustFoldBraces


syn region rustMacroRepeat matchgroup=rustMacroRepeatDelimiters start="$(" end=")" contains=TOP nextgroup=rustMacroRepeatCount
syn match rustMacroRepeatCount ".\?[*+]" contained
syn match rustMacroVariable "$\w\+"

" Reserved (but not yet used) keywords {{{2
syn keyword   rustReservedKeyword alignof become do offsetof priv pure sizeof typeof unsized yield abstract virtual final override macro

" Built-in types {{{2
syn keyword   rustType        int float option list array unit ref bool string

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported core operators {{{3
syn keyword   rustTrait       Copy Send Sized Sync
syn keyword   rustTrait       Drop Fn FnMut FnOnce

" Reexported functions {{{3
" There’s no point in highlighting these; when one writes drop( or drop::< it
" gets the same highlighting anyway, and if someone writes `let drop = …;` we
" don’t really want *that* drop to be highlighted.
"syn keyword rustFunction drop

" Reexported types and traits {{{3
syn keyword rustTrait Box
syn keyword rustTrait ToOwned
syn keyword rustTrait Clone
syn keyword rustTrait PartialEq PartialOrd Eq Ord
syn keyword rustTrait AsRef AsMut Into From
syn keyword rustTrait Default
syn keyword rustTrait Iterator Extend IntoIterator
syn keyword rustTrait DoubleEndedIterator ExactSizeIterator
syn keyword rustEnum Option
syn keyword rustEnumVariant Some None
syn keyword rustEnum Result
syn keyword rustEnumVariant Ok Err
syn keyword rustTrait SliceConcatExt
syn keyword rustTrait String ToString
syn keyword rustTrait Vec

" Other syntax {{{2
syn keyword   rustSelf        self
syn keyword   rustBoolean     true false

" This is merely a convention; note also the use of [A-Z], restricting it to
" latin identifiers rather than the full Unicode uppercase. I have not used
" [:upper:] as it depends upon 'noignorecase'
"syn match     rustCapsIdent    display "[A-Z]\w\(\w\)*"

syn match     rustOperator     display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"
" This one isn't *quite* right, as we could have binary-& with a reference

" This isn't actually correct; a closure with no arguments can be `|| { }`.
" Last, because the & in && isn't a sigil
syn match     rustOperator     display "&&\|||"
" This is rustArrowCharacter rather than rustArrow for the sake of matchparen,
" so it skips the ->; see http://stackoverflow.com/a/30309949 for details.
syn match     rustArrowCharacter display "=>"

syn match     rustEscapeError   display contained /\\./
syn match     rustEscape        display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match     rustEscapeUnicode display contained /\\\(u\x\{4}\|U\x\{8}\)/
syn match     rustEscapeUnicode display contained /\\u{\x\{1,6}}/
syn match     rustStringContinuation display contained /\\\n\s*/
syn region    rustString      start='{j|' end='|j}' contains=rustMacroVariable,@Spell
syn region    rustString      start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeError,rustStringContinuation
syn region    rustString      start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeUnicode,rustEscapeError,rustStringContinuation,@Spell
syn region    rustString      start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

syn region    rustAttribute   start="#!\?\[" end="\]" contains=rustString,rustDerive
syn region    rustDerive      start="derive(" end=")" contained contains=rustDeriveTrait
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).
syn keyword   rustDeriveTrait contained Clone Hash RustcEncodable RustcDecodable Encodable Decodable PartialEq Eq PartialOrd Ord Rand Show Debug Default FromPrimitive Send Sync Copy

" Number literals
syn match     rustDecNumber   display "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     rustHexNumber   display "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     rustOctNumber   display "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     rustBinNumber   display "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     rustFloat       display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!"
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     rustFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match     rustFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match     rustFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

" For the benefit of delimitMate

syn match   rustCharacterInvalid   display contained /b\?'\zs[\n\r\t']\ze'/
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   rustCharacterInvalidUnicode   display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/
syn match   rustCharacter   /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=rustEscape,rustEscapeError,rustCharacterInvalid,rustCharacterInvalidUnicode
syn match   rustCharacter   /'\([^\\]\|\\\(.\|x\x\{2}\|u\x\{4}\|U\x\{8}\|u{\x\{1,6}}\)\)'/ contains=rustEscape,rustEscapeUnicode,rustEscapeError,rustCharacterInvalid

syn match rustShebang /\%^#![^[].*/
syn region rustCommentLine                                        start="//"                      end="$"   contains=rustTodo,@Spell
syn region rustCommentLineDoc                                     start="//\%(//\@!\|!\)"         end="$"   contains=rustTodo,@Spell
syn region rustCommentBlock    matchgroup=rustCommentBlock        start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=rustTodo,rustCommentBlockNest,@Spell
syn region rustCommentBlockDoc matchgroup=rustCommentBlockDoc     start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=rustTodo,rustCommentBlockDocNest,@Spell
syn region rustCommentBlockNest matchgroup=rustCommentBlock       start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockNest,@Spell contained transparent
syn region rustCommentBlockDocNest matchgroup=rustCommentBlockDoc start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockDocNest,@Spell contained transparent
" FIXME: this is a really ugly and not fully correct implementation. Most
" importantly, a case like ``/* */*`` should have the final ``*`` not being in
" a comment, but in practice at present it leaves comments open two levels
" deep. But as long as you stay away from that particular case, I *believe*
" the highlighting is correct. Due to the way Vim's syntax engine works
" (greedy for start matches, unlike Rust's tokeniser which is searching for
" the earliest-starting match, start or end), I believe this cannot be solved.
" Oh you who would fix it, don't bother with things like duplicating the Block
" rules and putting ``\*\@<!`` at the start of them; it makes it worse, as
" then you must deal with cases like ``/*/**/*/``. And don't try making it
" worse with ``\%(/\@<!\*\)\@<!``, either...

syn keyword rustTodo contained TODO FIXME XXX NB NOTE

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region rustFoldBraces start="{" end="}" transparent fold

" Default highlighting {{{1
hi def link labelArgument       Special
hi def link labelArgumentPunned Special
hi def link rustDecNumber       rustNumber
hi def link rustHexNumber       rustNumber
hi def link rustOctNumber       rustNumber
hi def link rustBinNumber       rustNumber
hi def link rustIdentifierPrime rustIdentifier
hi def link rustTrait           rustType
hi def link rustDeriveTrait     rustTrait

hi def link rustMacroRepeatCount   rustMacroRepeatDelimiters
hi def link rustMacroRepeatDelimiters   Macro
hi def link rustMacroVariable Define
hi def link rustEscape        Special
hi def link rustEscapeUnicode rustEscape
hi def link rustEscapeError   Error
hi def link rustStringContinuation Special
hi def link rustString        String
hi def link rustCharacterInvalid Error
hi def link rustCharacterInvalidUnicode rustCharacterInvalid
hi def link rustCharacter     Character
hi def link rustNumber        Number
hi def link rustBoolean       Boolean
hi def link rustEnum          rustType
hi def link rustEnumVariant   Function
hi def link rustModPath       Macro
hi def link rustConstant      Constant
hi def link rustSelf          Constant
hi def link rustFloat         Float
hi def link rustArrowCharacter rustOperator
hi def link rustOperator      Keyword
hi def link rustKeyword       Keyword
hi def link rustReservedKeyword Error
hi def link rustConditional   StorageClass
hi def link rustIdentifier    Identifier
hi def link rustCapsIdent     rustIdentifier
hi def link rustFunction      Function
hi def link rustFuncName      Function
hi def link rustShebang       Comment
hi def link rustCommentLine   Comment
hi def link rustCommentLineDoc Comment
hi def link rustCommentBlock  rustCommentLine
hi def link rustCommentBlockDoc rustCommentLineDoc
hi def link rustAssert        PreCondit
hi def link rustPanic         PreCondit
hi def link rustType          Type
hi def link rustTodo          Todo
hi def link rustAttribute     PreProc
hi def link rustDerive        PreProc
hi def link rustStorage       Conditional
hi def link rustStorageIdent StorageClass
hi def link rustObsoleteStorage Error
hi def link rustExternCrate   rustKeyword
hi def link rustObsoleteExternMod Error
hi def link rustBoxPlacementParens Delimiter

" Other Suggestions:
" hi rustAttribute ctermfg=cyan
" hi rustDerive ctermfg=cyan
" hi rustAssert ctermfg=yellow
" hi rustPanic ctermfg=red

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "rust"
