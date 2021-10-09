# vim-ref-clojuredocs

vim-ref-clojuredocs is a plugin for searching Clojure documentation from https://clojuredocs.org/ .
Since it uses https://clojuredocs.org/clojuredocs-export.json as a reference, it does not need to run REPL.

## Install

vim-plug:

```
Plug 'thinca/vim-ref'
Plug 'nanonanomachine/vim-ref-clojuredocs'
```

## Prequisites

- `markdown` syntax is supported
  -  You can use `markdown` syntax via [sheerun/vim-polyglot](https://github.com/sheerun/vim-polyglot) or [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown)
- `curl` is installed
- https://github.com/thinca/vim-ref is installed

## How to use it

Press `K` on the function you want to check the document, or run the following command:

```bash
:Ref clojuredocs <function>
```

If you use clojure plugins such as [liquidz/vim-iced](https://github.com/liquidz/vim-iced) or [tpope/vim-fireplace](https://github.com/tpope/vim-fireplace) and use their default key mappings, vim-ref's default key mapping `K` will be overwritten. You need to disable their default key mappings or reassign vim-ref's key map as follows:

```vim
" Workaround for overwritten the default key mapping by vim-iced
silent! nmap <silent> <unique> KK <Plug>(ref-keyword)
silent! xmap <silent> <unique> KK <Plug>(ref-keyword)
```

## Todo

- Set an expiration date for a cached json file
