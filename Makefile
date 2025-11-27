.PHONY: serve stop watch build test see lint

serve:	build
	(cd public && ../serve1355 >../serve1355.log 2>&1) &

stop:
	pkill -fec 'serve1355'

watch:
	watchexec --watch=./ --watch=./public --exts=js,json,m4 $(MAKE) build

build: public/index.html public/test.html
	@echo "BUILT"

test:
	open http://localhost:1355/test.html

see:
	open http://localhost:1355/index.html

lint:
	deno lint


public/%.html: src/%.html.m4 $(wildcard ./importmap*.json) $(wildcard ./public/**.js)
	m4 --define=M4_BUSTER=$(shell openssl rand 6 | base64) --prefix-builtins $< > $@

