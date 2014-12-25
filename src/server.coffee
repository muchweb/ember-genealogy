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
	person: new nedb
		filename: 'data/person.json'
		autoload: yes

database.person.findOne
	_id: "0"
, (error, item) ->
	throw error if error?
	(new Person).FromDatabase item, (person) ->
		(person.get 'names').forEach (item) ->
			console.log item.get 'full'
