.PHONY: serve serve-couchdb stop watch build test see lint
DATA_VOLUME=buildless-couchdb-data

serve:	build serve-couchdb
	(cd public && ../bin/serve1355 >../serve1355.log 2>&1) &

setup:
	./bin/addUsers

serve-couchdb:
	-docker stop buildless-couchdb
	docker build . --file=./couchdb.dockerfile -t buildless-couchdb:latest &&\
	docker run --rm -d --name buildless-couchdb\
		 -e COUCHDB_USER=admin \
		 -e COUCHDB_PASSWORD=password \
		 -p 15984:5984 \
		 --mount type=volume,src=$(DATA_VOLUME),dst=/opt/couchdb/data \
	         buildless-couchdb:latest

stop:
	-docker stop buildless-couchdb
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

