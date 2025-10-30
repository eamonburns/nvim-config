; Custom highlight for special blockquote callouts

(shortcut_link
  (link_text) @_text
  (#match? @_text "NOTE")) @comment.note

; (block_quote
;   (paragraph
;     (inline) @_note_marker
;     (#match? @_note_marker "\\\[!NOTE\\\]"))) @comment.note
