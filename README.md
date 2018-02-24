# Vim support for Reason/OCaml

## Prerequisite

You'll need either Vim with Python 3 support, or Neovim. If you're on Vim with Python 2, please use our [old plugin](https://github.com/reasonml-editor/vim-reason-legacy).

## Features

This plugin simply uses our [language server](https://github.com/freebroccolo/ocaml-language-server#server-capabilities). Every feature is supported. Additionally, we provide the basics: snippets and syntax highlighting.

## Installing

If you are using a plugin manager, add a line such as the following to your `.vimrc`:

```
" If using NeoBundle
NeoBundle 'reasonml-editor/vim-reason-plus'

" Or, if using Vundle
Bundle 'reasonml-editor/vim-reason-plus'

" Or, if using Vim-Plug
Plug 'reasonml-editor/vim-reason-plus'
```

You also need to install Vim/NeoVim's [Language Client](https://github.com/autozimu/LanguageClient-neovim). Do follow its "Quick Start" section. The Reason configuration for that section is the following:

```viml
let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ }
```

You'll also need to install `ocaml-language-server` globally, so the Language Client can start it from the editor:

```
npm install -g ocaml-language-server
```

If the Quick Start instructions didn't work, make sure you read the [complete installation guide](https://github.com/autozimu/LanguageClient-neovim/blob/master/INSTALL.md). It's probably a Python issue.

See its guide on calling the available features and assigning shortcuts to them, e.g. `LanguageClient_textDocument_definition`.

## Configuration

Please follow [LanguageClient-neovim's documentation on how to configure features](https://github.com/autozimu/LanguageClient-neovim/blob/db1a3cfca09dbfd4350fe04c10084194d77cca1c/doc/LanguageClient.txt#L199). Here's an example configuration you'd put in `.vimrc`:

```
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<cr>
nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<cr>
nnoremap <silent> <cr> :call LanguageClient_textDocument_hover()<cr>
```

Triggering `gf` in normal mode would format the buffer.

## LICENSE

Some files from vim-reason-plus are based on the Rust vim plugin and so we are including that license.
