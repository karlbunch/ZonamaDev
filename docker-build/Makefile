.PHONY: build

build:
	docker build -t swgemu/core3:unstable .

build-nocache:
	docker build --no-cache -t swgemu/core3:unstable .

run:
	docker run -it -e DBHOST='147.75.79.91' -e DBUSER='root' -e DBPASS='12345678' -v core3-data-test:/core3-data swgemu/core3:unstable
