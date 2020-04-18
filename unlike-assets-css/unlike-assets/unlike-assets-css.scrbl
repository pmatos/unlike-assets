#lang scribble/manual

@title{Unlike Asset: Cascading Style Sheets (CSS)}

@require[@for-label[racket/base]]
@defmodule[unlike-assets/css]

This module produces CSS stylesheets as living assets.

@section{Racket-CSS Pidgin Language}
@defmodule[unlike-assets/css/pidgin #:lang]

When used as a @litchar{#lang},
@racketmodname[unlike-assets/css/pidgin] reads a section of Racket
code followed by a section of CSS Expressions as per
@racketmodname[css-expr]. All style declarations are accumulated, then
provided as a minified string.

The Racket section has all of the bindings from
@racketmodname[racket/base], @racketmodname[unlike-assets/css], and
@racketmodname[css-expr] available for use.

@racketmod[unlike-assets/css
(code:comment "You can write racket/base code normally")
(require racket/format)

(code:comment "You can declare variables for later interpolation.")
(define color '|#888|)

(code:comment "You can use macros in the Racket section to add style declarations")
(code:comment "that would be painful to write by hand.")
(add-css-expr! (font-face "code" "fonts/sourcecodepro-bold-webfont" 'normal 'bold))

(code:comment "CSS expressions start in a named section.")
#:begin-css

[* #:box-sizing border-box]
[h1 #:text-transform uppercase]
[.my-widget #:color ,color]
]
