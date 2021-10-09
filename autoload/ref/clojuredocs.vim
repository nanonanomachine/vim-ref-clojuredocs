let s:save_cpo = &cpo
set cpo&vim

let s:cache_json_path = expand("<sfile>:p:h:h:h").'/.cache/clojuredocs-export.json'
let s:source = {'name' : 'clojuredocs'}

function! s:download_clojuredocs_json()
  " TODO: add expiration period
  if empty(glob(s:cache_json_path))
     return ref#system(['curl', 'https://clojuredocs.org/clojuredocs-export.json', '--output', s:cache_json_path])
  endif
endfunction

function! s:clojure_docs_lookup(query) abort
  call s:download_clojuredocs_json()
  let l:clojure_docs_json = json_decode(readfile(s:cache_json_path))

  " Read json file
  let l:target = filter(l:clojure_docs_json['vars'], 'v:val["name"] =="'.a:query.'"')
  if(len(l:target) == 0)
    return 'Not found'
  elseif(len(l:target) > 1)
    return 'There are '.len(l:target).'candidates. Abort.'
  endif

  let l:target = l:target[0]

  " doc
  let l:doc = [
        \  '# '.l:target['ns'].'/'.l:target['name'],
        \  '`('.l:target['name'].' '.l:target['arglists'][0].')`',
        \  '',
        \  l:target['doc']
        \  ]

  " Example
  let l:examples = []
  if(type(l:target['examples']) == 3)
    let l:examples = ['### '.len(l:target['examples']).' examples']
    let l:example_num = 1
    for l:example in l:target['examples']
      let example_description = [
            \ '',
            \ '* Example '.l:example_num,
            \ '```clojure',
            \ trim(l:example['body']),
            \ '```',
            \ ]
      let l:examples = l:examples + l:example_description
      let l:example_num += 1
    endfor
  endif

  " See also
  let l:see_also = [
        \ '### See also',
        \  join(map(l:target['see-alsos'], '"* ".v:val["to-var"]["ns"]."/".v:val["to-var"]["name"]'), "\n")
        \]

  " Notes
  let l:notes = []
  if(type(l:target['notes']) == 3)
    let l:notes = ['### '.len(l:target['notes']).' notes']
    let l:note_num = 1
    for l:note in l:target['notes']
      let note_description = [
            \ '',
            \ '* Note'.l:note_num,
            \ trim(l:note["body"]),
            \ ]
      let l:notes = l:notes + l:note_description
      let l:note_num += 1
    endfor
  endif

  " Deal with new line
  let l:examples_formatted = []
  if (len(l:examples) > 0)
    let l:examples_formatted = ["\n"] + l:examples
  endif

  let l:notes_formatted = []
  if (len(l:notes) > 0)
    let l:notes_formatted = ["\n"] + l:notes
  endif

  " Final output
  let l:final_list = l:doc + l:examples_formatted + ["\n"] + l:see_also + l:notes_formatted
  let l:final_output = join(final_list, "\n")
  return l:final_output
endfunction

function! s:syntax()
  if exists('b:current_syntax') && b:current_syntax == 'markdown'
    return
  endif

  syntax clear
  set filetype=markdown

  let b:current_syntax = 'markdown'
endfunction

function! s:source.available()
    return executable('curl')
endfunction

function! s:source.get_body(query)
    return s:clojure_docs_lookup(a:query)
endfunction

function! s:source.opened(query)
  call s:syntax()
endfunction

function! s:source.get_keyword()
    let kwd = ref#get_text_on_cursor('^|\zs.*\ze|$')
    if kwd != ''
        return kwd
    endif

    return ref#get_text_on_cursor('[0-9A-Za-z]\+')
endfunction

function! s:source.normalize(query)
    return a:query
endfunction

function! ref#clojuredocs#define()
    return copy(s:source)
endfunction

call ref#register_detection('cojuredocs', 'clojuredocs')

let &cpo = s:save_cpo
unlet s:save_cpo
