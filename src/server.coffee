'use strict'

GLOBAL.window =
	console: console

require 'ember/runtime'

Person = require './Person.js'
Name   = require './Name.js'

p = Person.create
	names: [
		Name.create
			first: 'foo'
			last: 'foo'
	,
		Name.create
			first: 'bar'
			last: 'bar'
	]

(p.get 'names').forEach (name) ->
	console.log name.get 'full'
