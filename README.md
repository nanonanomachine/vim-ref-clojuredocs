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

```bash
:Ref clojuredocs <function>
```

## Todo

- More doucumentation
- Set an expiration date for a cached json file
