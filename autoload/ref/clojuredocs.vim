let s:save_cpo = &cpo
set cpo&vim

let s:source = {'name' : 'clojuredocs'}

function! s:download_clojuredocs_json()
    return ref#system(['curl', '-Ls', 'https://clojuredocs.org/clojuredocs-export.json']).stdout
endfunction

function! s:clojure_docs_lookup(query) abort
  " read json file
  let l:clojure_docs_json = json_decode(s:download_clojuredocs_json())
  let l:target = l:clojure_docs_json[a:query]

  " doc
  let l:doc = [
        \  '# '.l:target['ns'].'/'.l:target['name'],
        \  '`('.l:target['name'].' '.l:target['arglists'][0].')`',
        \  '',
        \  l:target['doc']
        \  ]

  " Example
  let l:examples = ['### '.len(l:target['examples']).' examples']
  let l:example_num = 1
  for l:example in l:target['examples']
    let example_description = [
          \ '',
          \ '* Example '.l:example_num,
          \ '```clojure',
          \ l:example,
          \ '```',
          \ ]
    let l:examples = l:examples + l:example_description
    let l:example_num += 1
  endfor

  " See also
  let l:see_also = [
        \ '### See also',
        \  join(map(l:target['see-alsos'], '"* ".v:val'), "\n")
        \]

  " Notes
  let l:notes = ['### '.len(l:target['notes']).' notes']
  let l:note_num = 1
  for l:note in l:target['notes']
    let note_description = [
          \ '',
          \ '* Note'.l:note_num,
          \ l:note,
          \ ]
    let l:notes = l:notes + l:note_description
    let l:note_num += 1
  endfor
  let l:final_output = join(l:doc + ["\n"] + l:examples + ["\n"] + l:see_also + ["\n"] + l:notes, "\n")
  return l:final_output
endfunction

function! s:source.available()
    return executable('curl')
endfunction

function! s:source.get_body(query)
    return s:clojure_docs_lookup(a:query)
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
