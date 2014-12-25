'use strict'

GLOBAL.window =
	console: console

require 'ember/runtime'

Person = require './Person.js'
Name   = require './Name.js'

p = Person.create
	names: [
		Name.create
			title: 'Mr.'
			given: 'foo'
			surname: 'bar'
	,
		Name.create
			given: 'bar'
			surname: 'bar'
	]

(p.get 'names').forEach (name) ->
	console.log name.get 'full'


nedb = require 'nedb'

database =
	nametype: new nedb
		filename: 'data/nametype.json'
		autoload: yes

database.nametype.find {}, (error, items) ->
	throw error if error?
	console.log items
