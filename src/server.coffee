'use strict'

GLOBAL.window = {}
GLOBAL.window.console = console

require 'ember/runtime'

nedb = require 'nedb'
Person = require './Person.js'

GLOBAL.database =
	nametype: new nedb
		filename: 'data/nametype.json'
		autoload: yes
	name: new nedb
		filename: 'data/name.json'
		autoload: yes
	nameorigin: new nedb
		filename: 'data/nameorigin.json'
		autoload: yes
	person: new nedb
		filename: 'data/person.json'
		autoload: yes
	gender: new nedb
		filename: 'data/gender.json'
		autoload: yes

database.person.find {}, (error, items) ->
	throw error if error?
	for item in items
		((new Person).FromDatabase item).then (person) ->
			console.log "== #{person.get 'display'} =="
			(person.get 'names').forEach (item) ->
				console.log " - #{item.get 'full'}"
