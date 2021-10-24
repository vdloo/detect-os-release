# detect-os-release

A small Racket library to detect the OS the program is currently running on.

# Description

Looks at `/etc/os-release` to identify the operating system.

# Usage

Install the library by running
```
raco pkg install https://github.com/vdloo/detect-os-release.git
```

Or by adding it to the `deps` of your `info.rkt` file:
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
"arch"  ; output
```

# Development

To run the unit tests for `detect-os-release` run:
```
make test
```
