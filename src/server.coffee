'use strict'

global.window =
	console: console
	App: {}

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

express()
	.use express.static path.normalize "#{__dirname}/.."
	.get '/people', (req, res) ->
		database.person.find {}, (error, items) ->
			throw error if error?

			(q.all items.map (item) ->
				deferred = q.defer()
				setImmediate =>
					console.log 'item',  item
					((new Person).FromDatabase item).then (person) ->
						deferred.resolve
							id: person.get '_id'
							gender: person.get 'gender._id'
							name: person.get 'name._id'
							names: (person.get 'names').map (name) ->
								name.get '_id'
				deferred.promise
			).then (people) ->
				res.send
					people: people
	.listen 8000

console.log 'Running on localhost:8000...'
