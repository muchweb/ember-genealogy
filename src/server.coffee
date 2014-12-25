'use strict'

global.window = {}
global.window.console = console
require 'ember/runtime'

global.DS =
	Model: Ember.Object.extend
		id: ''
	attr: (type) -> type
	belongsTo: -> '-1'
	hasMany: -> ['-1']

global.q   = require 'q'
nedb       = require 'nedb'
path       = require 'path'
bodyparser = require 'body-parser'
express    = require 'express'

global.Person     = require './models/Person.js'
global.Name       = require './models/Name.js'
global.Gender     = require './models/Gender.js'
global.Nametype   = require './models/Nametype.js'
global.Nameorigin = require './models/Nameorigin.js'

global.database =
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

express()
	.use express.static path.normalize "#{__dirname}/.."
	.listen 8000

console.log 'Running on localhost:8000...'
