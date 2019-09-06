# Debian minimal image
This will provide a GNU/Linux Debian minimal base system with a few network apps for my students.

## How to use this image
This image only contains a few system apps and an editor (VIm). 

`
$ docker run -it mmasquelin/debian-minimal-rx:latest
`

Option `-i` (or --interactive) keeps STDIN open even if not attached.
Option `-t` (or --tty) allocates a pseudo-TTY
