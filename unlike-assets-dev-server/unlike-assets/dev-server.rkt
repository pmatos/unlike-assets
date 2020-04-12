#lang racket/base

(require racket/contract
         web-server/http/request-structs
         web-server/http/response-structs
         unlike-assets/reactive
         unlike-assets/conventions
         web-server/dispatchers/dispatch)

(define procure-responder/c
  (-> string? (asset/c [->http-response (-> request? response?)])))

(provide
 (contract-out
  [make-dispatcher (-> procure-responder/c dispatcher/c)]
  [start-server (->* (procure-responder/c) (exact-positive-integer?) procedure?)]))

(require net/url
         racket/format
         racket/function
         racket/string
         web-server/web-server
         unlike-assets/logging
         (prefix-in lifter:
                    web-server/dispatchers/dispatch-lift))

(define (capture-error-display e)
  (parameterize ([current-error-port (open-output-string)])
    ((error-display-handler) (exn-message e) e)
    (get-output-string (current-error-port))))

(define (show-error e)
  (response/output #:code 500
                   #:mime-type #"text/plain; charset=utf-8"
                   (λ (o) (write-bytes (string->bytes/utf-8 (capture-error-display e)) o))))

(define (default-url->asset-key u)
  (string-join (map path/param-path (url-path u)) "/"))

(define (make-dispatcher [url->asset-key default-url->asset-key])
  (lifter:make
   (λ (req)
     (with-handlers ([exn:fail? show-error])
       ((Ps/c (url->asset-key (request-uri req))
              asset/serveable/c)
        '->http-response)
       req))))

(define (start-server url->asset-key [port 8080])
  (serve #:dispatch (make-dispatcher url->asset-key)
         #:port port))