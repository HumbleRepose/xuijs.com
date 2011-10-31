VERSION = `cat ./../xui/VERSION`

deploy: min copy-docs copy-downloads copy-tests
	git push joyent master

min:
	java -jar ./lib/yuicompressor-2.4.2/build/yuicompressor-2.4.2.jar ./public/grid.css -o ./public/grid.min.css
	java -jar ./lib/yuicompressor-2.4.2/build/yuicompressor-2.4.2.jar ./public/app.css -o ./public/app.min.css
	java -jar ./lib/yuicompressor-2.4.2/build/yuicompressor-2.4.2.jar ./public/prettify.css -o ./public/prettify.min.css
	java -jar ./lib/yuicompressor-2.4.2/build/yuicompressor-2.4.2.jar ./public/prettify.js -o ./public/prettify.min.js

copy-docs:
	mkdir -p ./views/docs
	cd ../xui && ./build --generate-docs
	cp ./../xui/doc/ejs/* ./views/docs

copy-downloads:
	cd ../xui && ./build --minify
	cd ../xui && ./build profile=bb --minify
	cd ../xui && ./build profile=ie --minify
	cp ./../xui/lib/xui-${VERSION}.js 		./public/downloads/xui-${VERSION}.js
	cp ./../xui/lib/xui-${VERSION}.min.js	./public/downloads/xui-${VERSION}.min.js
	cp ./../xui/lib/xui-bb-${VERSION}.js		./public/downloads/xui-bb-${VERSION}.js
	cp ./../xui/lib/xui-bb-${VERSION}.min.js	./public/downloads/xui-bb-${VERSION}.min.js
	cp ./../xui/lib/xui-ie-${VERSION}.js		./public/downloads/xui-ie-${VERSION}.js
	cp ./../xui/lib/xui-ie-${VERSION}.min.js ./public/downloads/xui-ie-${VERSION}.min.js

# warning: do not copy submodules around! that REALLY fucks up git
copy-tests:
	rm -rf ./public/tests/*
	mkdir -p ./public/tests/packages/qunit/qunit
	cp ./../xui/packages/qunit/qunit/qunit.css ./public/tests/packages/qunit/qunit/qunit.css
	cp ./../xui/packages/qunit/qunit/qunit.js ./public/tests/packages/qunit/qunit/qunit.js
	cp -r ./../xui/spec ./public/tests/tests
	cp -r ./../xui/lib  ./public/tests/lib

.PHONY: all
