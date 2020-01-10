SHELL = /usr/bin/env bash

all: build jar clean

build:
	@javac -d ./bin ./src/main/*.java

# You have to run `jar` from the directory that has your packages at the
# top-level, i.e. not where `bin/` is visible, and therefore inside `bin/`
jar:
	@cd bin && jar -cvmf ../MANIFEST.MF main.jar ./main/*.class

clean:
	@rm ./bin/main/*.class > /dev/null 2>&1 || exit 0

run:
	@java -jar ./bin/main.jar
