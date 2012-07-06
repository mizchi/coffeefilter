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

test:
	cake test

bench:
	cake bench

docs:
	cake docs
