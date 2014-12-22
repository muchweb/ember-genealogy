LIB=lib/server.js lib/server.js.map
SRC=src/server.coffee

all: $(LIB)

$(LIB): ./node_modules/.bin/coffee $(SRC)
	./node_modules/.bin/coffee --map --compile --output lib src

./node_modules/.bin/coffee:
	npm install
