SRC = lib/coffeefilter.js lib/cli.js

all: preparation lib

preparation:
	@mkdir -p lib

lib: $(SRC)

lib/%.js: src/%.coffee
	coffee -o lib -c $<

clean:
	@echo "Cleaning coffeefilter..."
	rm -rf lib

.PHONY: test
test: all
	@#cake test
	mocha --compilers coffee:coffee-script --ui tdd

bench:
	cake bench

docs:
	cake docs
