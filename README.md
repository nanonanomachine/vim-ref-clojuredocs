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

- `curl` is installed
- https://github.com/thinca/vim-ref is installed

## How to use it

```bash
:Ref clojuredocs <function>
```

## Todo

- Markdown syntax highlight setting
- More doucumentation
- Set an expiration date for a cached json file
