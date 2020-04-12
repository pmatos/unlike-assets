#lang racket/base

(require (for-syntax racket/base racket/syntax racket/list))

; Avoids empty attribute lists.
(provide children-only)
(define (children-only el body)
  (keyword-apply el null null body))

(define (make-html-proc tag-name)
  (make-keyword-procedure
   (λ (kws args . formals)
     (apply list
            tag-name
            (if (eq? kws '())
                formals
                (cons
                 (map (λ (k v) (list (string->symbol (keyword->string k)) v)) kws args)
                 formals))))))

(define-syntax (define-tag-procs stx)
  (syntax-case stx ()
    [(_ tag-name ...)
     (with-syntax ([(provided-name ...)
                    (map (λ (s) (format-id s "h:~a" s))
                         (syntax->list #'(tag-name ...)))])
       #'(begin
           (begin (provide provided-name)
                  (define provided-name (make-html-proc 'tag-name)))
           ...))]))

(define-tag-procs
a abbr acronym address applet area article aside audio b base basefont
bdi bdo bgsound big blink blockquote body br button canvas caption
center cite code col colgroup command content data datalist dd del
details dfn dialog dir div dl dt element em embed fieldset figcaption
figure font footer form frame frameset h1 h2 h3 h4 h5 h6 head header
hgroup hr html i iframe image img input ins isindex kbd keygen label
legend li link listing main map mark marquee menu menuitem meta meter
multicol nav nextid nobr noembed noframes noscript object ol optgroup
option output p param picture plaintext pre progress q rb rp rt rtc
ruby s samp script section select shadow slot small source spacer span
strike strong style sub summary sup table tbody td template textarea
tfoot th thead time title tr track tt u ul var video wbr xmp)