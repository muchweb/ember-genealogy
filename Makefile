SOURCES := $(wildcard src/*.coffee) $(wildcard src/models/*.coffee)
LIBS1   := $(SOURCES:.coffee=.js)
LIBS    := $(subst src,lib,$(LIBS1))
COFFEE  := ./node_modules/.bin/coffee
BOWER   := ./node_modules/.bin/bower
SCRIPTS := lib/ember.js lib/ember-data.js lib/handlebars.js lib/jquery.js

all: $(LIBS) $(SCRIPTS)

$(LIBS): $(COFFEE) $(SOURCES)
	$(COFFEE) --map --compile --output lib src

lib/jquery.js: bower_components
	cp bower_components/jquery/dist/jquery.js lib/jquery.js

lib/handlebars.js: bower_components
	cp bower_components/handlebars/handlebars.js lib/handlebars.js

lib/ember.js: bower_components
	cp bower_components/ember/ember.js lib/ember.js

lib/ember-data.js: bower_components
	cp bower_components/ember-data/ember-data.js lib/ember-data.js

bower_components: $(BOWER)
	$(BOWER) install

$(COFFEE) $(BOWER):
	npm install
