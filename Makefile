.PHONY: run restart help build-static

run: build-static
	./result/bin/sigpr run echo 'test'
restart: build-static
	./result/bin/sigpr restart
help: build-static
	./result/bin/sigpr help
build-static:
	hpack
	nix build
