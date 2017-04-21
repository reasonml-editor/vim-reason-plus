VimReason: Vim support for Reason
=========================================

Configuring Vim Via a Plugin Manager
------------------

If you are using a plugin manager, add a line such as the following
to your `.vimrc` file (or wherever you load bundles).

```
" If using NeoBundle(recommended)
NeoBundle 'chenglou/vim-reason'

" Or, if using Vundle
Bundle 'chenglou/vim-reason'
```
Install a `Reason` Toolchain.
------------------
If you haven't already began the process of installing `Reason`, follow the
[latest
instructions](https://github.com/facebook/Reason/blob/master/README.md#install-via-npm).


Formatting:
===========

The command `:ReasonPrettyPrint` invokes the binary `refmt` which must be
available on your `PATH`.

`VimReason`, doesn't use Vim's standard external formatting program bridge
because it disturbs your undo history and cursor position. Instead,
`VimReason`, implements its own buffer updates so that no modifications to your
buffer occur if the file is already formatted, and only lines requiring updates
are actually modified (so that undo/redo take you to the position where
formatting actually effected the file).

You can set `g:vimreason_extra_args_expr_reason` to control the arguments
passed to `refmt` (such as `--print-width`). The contents of
`g:vimreason_extra_args_expr_reason` is a string that contains a `VimScript`
expression. This allows you do dynamically determine the formatting arguments
based on things like your window width.

```vim
" Always wrap at 90 columns
let g:vimreason_extra_args_expr_reason = '"--print-width 90"'

" Wrap at the window width
let g:vimreason_extra_args_expr_reason = '"--print-width " . ' .  "winwidth('.')"

" Wrap at the window width but not if it exceeds 120 characters.
let g:vimreason_extra_args_expr_reason = '"--print-width " . ' .  "min([120, winwidth('.')])"
```

Key Mappings:
=============

You can create a custom function and map it to a keybinding (in your `.vimrc`)
to quickly trigger formatting, and control how the formatting occurs. To enable
keymappings *only* for `reason` files, your vim must have been compiled with
`+localmap` (`:echo has('localmap')` should output `1` if your vim supports it).

For example, the following maps `cmd + shift + m` to reformat only when editing
a `reason` file.

```vim
autocmd FileType reason map <buffer> <D-M> :ReasonPrettyPrint<Cr>
```


Merlin:
===========
If you have `merlin` installed, `VimReason` will also activate it for `reason`
files. Completions should work well, but most other things don't. `VimReason`
can't rely on `merlin` compilation, but does scan the `.merlin` file to pick
out flags and include paths so that it can compile individual files and report
compiler errors to syntastic.


Brace Completion:
============
`VimBox` already comes with `PairTools`, but if you don't have `VimBox`, install it using `Vundle`:

```vim
NeoBundle "git://github.com/MartinLafreniere/vim-PairTools.git"
```

Seriously - you should install `PairTools`. It is perhaps the best brace completion plugin for Vim.

Once you have `PairTools`, add this configuration in your `.vimrc`:

```vim
autocmd FileType reason let g:pairtools_reason_pairclamp = 1
autocmd FileType reason let g:pairtools_reason_tagwrench = 0
autocmd FileType reason let g:pairtools_reason_jigsaw    = 1
autocmd FileType reason let g:pairtools_reason_autoclose  = 1
autocmd FileType reason let g:pairtools_reason_forcepairs = 0
autocmd FileType reason let g:pairtools_reason_closepairs = "(:),[:],{:}" . ',":"'
autocmd FileType reason let g:pairtools_reason_smartclose = 1
autocmd FileType reason let g:pairtools_reason_smartcloserules = '\w,(,&,\*'
autocmd FileType reason let g:pairtools_reason_antimagic  = 1
autocmd FileType reason let g:pairtools_reason_antimagicfield  = "Comment,String,Special"
autocmd FileType reason let g:pairtools_reason_pcexpander = 1
autocmd FileType reason let g:pairtools_reason_pceraser   = 1
autocmd FileType reason let g:pairtools_reason_tagwrenchhook = 'tagwrench#BuiltinNoHook'
autocmd FileType reason let g:pairtools_reason_twexpander = 0
autocmd FileType reason let g:pairtools_reason_tweraser   = 0
autocmd FileType reason let g:pairtools_reason_apostrophe = 0
```

LICENSE
-------
Some files from VimReason are based on the Rust vim plugin and so we are including that license.





Configuring Vim Manually.
------------------
If you don't use a Vim plugin manager, you can add the following to your
"vim rc" folder (usually `~/.vimrc`). This will load
the `Reason` and `merlin` Vim plugins from `Reason` itself, wherever it is
installed. Normally, you'd load Vim plugins through some kind of a plugin manager,
but this approach below allows the plugins to always be in sync with whatever version of
`Reason` your project (or `PATH`) uses.

```vim
" In your ~/.vimrc
if executable('ocamlmerlin')
  " To set the log file and restart:
  let s:ocamlmerlin=substitute(system('which ocamlmerlin'),'ocamlmerlin\n$','','') . "../share/merlin/vim/"
  execute "set rtp+=".s:ocamlmerlin
  let g:syntastic_ocaml_checkers=['merlin']
endif
if executable('refmt')
  let s:reason=substitute(system('which refmt'),'refmt\n$','','') . "../share/reason/editorSupport/VimReason"
  execute "set rtp+=".s:reason
  let g:syntastic_reason_checkers=['merlin']
endif
```
