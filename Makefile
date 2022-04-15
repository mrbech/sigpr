run: build-static
	./sigpr run echo 'test'
restart: build-static
	./sigpr restart
help: build-static
	./sigpr help
build-static:
	hpack && cabal install --installdir=. --install-method=copy --enable-executable-stripping --disable-debug-info --overwrite-policy=always
cabal-install-static:
	hpack && cabal install --install-method=copy --enable-executable-stripping --disable-debug-info --overwrite-policy=always
