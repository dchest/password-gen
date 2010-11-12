#lang racket/gui

(require net/base64
         web-server/stuffers/hmac-sha1)


(define (gen-password secret url max-len)
  (substring (bytes->string/utf-8 
              (base64-encode 
               (HMAC-SHA1 (string->bytes/utf-8 secret) 
                          (string->bytes/utf-8 url))))
             0 max-len))


; Make a frame by instantiating the frame% class
(define frame (new frame% [label "Password Generator"]
                   [spacing 4]
                   [border 10]
                   [style '(no-resize-border)]
                   [min-width 300]))

(define secret-field (new text-field% [parent frame]
                          [label "Secret"]
                          [style '(single password vertical-label)]))

(define url-field (new text-field% [parent frame]
                       [label "URL"]
                       [style '(single vertical-label)]))

(define max-len-field (new text-field% [parent frame]
                           [label "Max password length "]
                           [init-value "20"]))


(new button% [parent frame]
     [label "Generate"]
     (callback (lambda (button event)
                 (let ([pwd (gen-password (send secret-field get-value) 
                                          (send url-field get-value)
                                          (string->number (send max-len-field get-value)))])
                   ; Update password field and show it
                   (send password-field set-value pwd)
                   (or (member password-field (send frame get-children)) 
                       (send frame add-child password-field))
                   ; Copy password to clipboard
                   (send the-clipboard set-clipboard-string pwd 0)))))

(define password-field (new text-field% [parent frame]
                            [label "Password"]
                            [style '(single deleted vertical-label)]))


; Show the frame by calling its show method
(send frame show #t)
