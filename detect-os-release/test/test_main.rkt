#!/usr/bin/env racket
#lang racket/base

(require rackunit)
(require rackunit/text-ui)
(require racket/file)

(require "../main.rkt")

(module+ test
  (define archlinux-os-release #<<EOF
NAME="Arch Linux"
PRETTY_NAME="Arch Linux"
ID=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://archlinux.org/"
DOCUMENTATION_URL="https://wiki.archlinux.org/"
SUPPORT_URL="https://bbs.archlinux.org/"
BUG_REPORT_URL="https://bugs.archlinux.org/"
LOGO=archlinux
EOF
)
  (define mock-file->string-with (λ (_) archlinux-os-release))

  (define main-tests
    (test-suite
      "Testsuite for detect-os-release/main.rkt -> detect-os"

      (test-case
        "Test that detect-os returns correct OS if Arch Linux"
        (define ret (detect-os #:file->string-with mock-file->string-with))

        (check-equal? "arch" ret)
      )

      (test-case
        "Test that detect-os returns correct OS if Debian"
        (define debian-os-release #<<EOF
PRETTY_NAME="Debian GNU/Linux 10 (buster)"
NAME="Debian GNU/Linux"
VERSION_ID="10"
VERSION="10 (buster)"
VERSION_CODENAME=buster
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
EOF
)
        (define mock-file->string-with (λ (_) debian-os-release))

        (define ret (detect-os #:file->string-with mock-file->string-with))

        (check-equal? "debian" ret)
      )

      (test-case
        "Test that detect-os returns correct OS if Fedora"
        (define fedora-os-release #<<EOF
NAME=Fedora
VERSION="32 (Workstation Edition)"
ID=fedora
VERSION_ID=32
PRETTY_NAME="Fedora 32 (Workstation Edition)"
ANSI_COLOR="0;38;2;60;110;180"
LOGO=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:32"
HOME_URL="https://fedoraproject.org/"
DOCUMENTATION_URL="https://docs.fedoraproject.org/en-US/fedora/f32/system-administrators-guide/"
SUPPORT_URL="https://fedoraproject.org/wiki/Communicating_and_getting_help"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_BUGZILLA_PRODUCT="Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=32
REDHAT_SUPPORT_PRODUCT="Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=32
PRIVACY_POLICY_URL="https://fedoraproject.org/wiki/Legal:PrivacyPolicy"
VARIANT="Workstation Edition"
VARIANT_ID=workstation
EOF
)
        (define mock-file->string-with (λ (_) fedora-os-release))

        (define ret (detect-os #:file->string-with mock-file->string-with))

        (check-equal? "fedora" ret)
      )

      (test-case
        "Test that detect-os opens /etc/os-release"
        (define check-equal-mock-file->string-with 
          (λ (actual-argument) 
            (check-equal? "/etc/os-release" actual-argument)
            (mock-file->string-with actual-argument)))

        (detect-os #:file->string-with check-equal-mock-file->string-with)
      )

      (test-case
        "Test that detect-os raises if error opening file"
        (define raising-mock-file->string-with 
          (λ (actual-argument) 
            (file->string "/tmp/etc/os-release-that-does-not-really-exist")))

        (check-exn exn:fail:contract?
          (λ () (detect-os #:file->string-with raising-mock-file->string-with)))
      )

      (test-case
        "Test that detect-os raises if empty file"
        (define mock-file->string-with (λ (_) ""))

        (check-exn exn:fail:contract?
          (λ () (detect-os #:file->string-with mock-file->string-with)))
      )

      (test-case
        "Test that detect-os raises if missing ID in /etc/os-release"
  (define missing-id-os-release #<<EOF
NAME="Arch Linux"
PRETTY_NAME="Arch Linux"
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://archlinux.org/"
DOCUMENTATION_URL="https://wiki.archlinux.org/"
SUPPORT_URL="https://bbs.archlinux.org/"
BUG_REPORT_URL="https://bugs.archlinux.org/"
LOGO=archlinux
EOF
)
        (define mock-file->string-with (λ (_) missing-id-os-release))

        (check-exn exn:fail:contract?
          (λ () (detect-os #:file->string-with mock-file->string-with)))
      )

      (test-case
        "Test that detect-os raises invalid ID entry"
  (define invalid-id-os-release #<<EOF
NAME="Arch Linux"
PRETTY_NAME="Arch Linux"
ID=
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://archlinux.org/"
DOCUMENTATION_URL="https://wiki.archlinux.org/"
SUPPORT_URL="https://bbs.archlinux.org/"
BUG_REPORT_URL="https://bugs.archlinux.org/"
LOGO=archlinux
EOF
)
        (define mock-file->string-with (λ (_) invalid-id-os-release))

        (check-exn exn:fail:contract?
          (λ () (detect-os #:file->string-with mock-file->string-with)))
      )
))

(run-tests main-tests))
