# detect-os-release

A small Racket library to detect the OS the program is currently running on.

# Description

Looks at `/etc/os-release` to identify the operating system. In the Racket standard library there is [system-type](https://docs.racket-lang.org/reference/runtime.html) which can tell you all kinds of interesting things about your environment and runtime, but it doesn't tell you on which Linux you're running. This library provides `detect-os-release` which will return the string `debian` if your running on Debian and so forth. This code depends on `/etc/os-release` existing. You can rely on this file existing on any system that runs [systemd](https://www.freedesktop.org/wiki/Software/systemd/). For more information about os-release see [here](https://www.freedesktop.org/software/systemd/man/os-release.html) or [here](https://0pointer.de/blog/projects/os-release).

# Usage

Install the library by running
```
raco pkg install https://github.com/vdloo/detect-os-release.git
```

Or by adding it to the `deps` of your `info.rkt` file before running `raco pkg update --update-deps`:
```
(define deps '("base"
	       "https://github.com/vdloo/detect-os-release.git"))
```

Then in your program:
```
; import the library
(require detect-os-release)

; use the function
(detect-os)
"debian"  ; output
```

# Development

To run the unit tests for `detect-os-release` run:
```
make test
```
