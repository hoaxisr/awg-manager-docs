.PHONY: dev build clean

dev:
	hugo server -D --bind 0.0.0.0

build:
	hugo --minify --cleanDestinationDir

clean:
	rm -rf public resources .hugo_build.lock
