# Vim support for Reason/OCaml

This is a version of [Reason](http://reasonml.github.io/) Vim editor integration without needing OPAM or dynamically loading the plugin. The only things you need are the 3 binaries described [here](https://reasonml.github.io/guide/editor-tools/global-installation).

## Prerequisite

You'll need either Vim with Python 3 support, or Neovim. If you're on Vim with Python 2, please use our [old plugin](https://github.com/reasonml-editor/vim-reason).

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

If the Quick Start instructions didn't work, make sure you read the [complete installation guide](https://github.com/autozimu/LanguageClient-neovim/blob/master/INSTALL.md). It's probably a Python issue.

See its guide on calling the available features and assigning shortcuts to them, e.g. `LanguageClient_textDocument_definition`.

## LICENSE

Some files from vim-reason-plus are based on the Rust vim plugin and so we are including that license.
