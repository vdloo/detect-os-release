#!/usr/bin/env racket
#lang racket/base

(require racket/file)
(require racket/string)
(require racket/list)

(provide detect-os)

(define os-release-file "/etc/os-release")

(define detect-os
  (λ (#:file->string-with [file->string file->string])

     (define read-os-release-content
       (λ ()
          (with-handlers 
            ([exn:fail?
               (λ (e)
                  (raise-arguments-error 
                    'os-release-file
                    (format "Could not read /etc/os-release. Failed to determine OS:\n~a" e)))])
            (file->string os-release-file))))

     (define os-release-lines-from-content
       (λ (os-release-content)
          (string-split os-release-content "\n")))

     (define get-os-id-lines
       (λ (os-release-lines)
          (filter
            (λ (line)
               (string-prefix? line "ID="))
            os-release-lines)))

     (define get-os-id-line
       (λ (os-release-lines)
          (let ((os-lines (get-os-id-lines os-release-lines)))
            (if (empty? os-lines)
              (raise-arguments-error 
                'os-release-invalid 
                (format 
                  (string-append
                    "Did not find the expected content in your ~a file. "
                    "Failed to determine OS") os-release-file))
              (car os-lines)))))

     (define get-os-from-os-id-line
       (λ (os-id-line)
          (let ((split-string (string-split os-id-line "=")))
            (if (< (length split-string) 2)
              (raise-arguments-error 
                'os-id-invalid
                (format 
                  (string-append
                    "Did not find the expected ID=<operating system> line in your ~a file. "
                    "Failed to determine OS") os-release-file))
              (cadr split-string)))))

     (get-os-from-os-id-line 
       (get-os-id-line 
         (os-release-lines-from-content 
           (read-os-release-content))))))
