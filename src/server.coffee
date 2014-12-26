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

	.get '/people/:id', (req, res) ->
		database.person.findOne
			_id: req.params.id
		, (error, item) ->
			throw error if error?
			((new Person).FromDatabase item).then (person) ->
				res.send
					person:
						id: person.get '_id'
						gender: person.get 'gender._id'
						name: person.get 'name._id'
						names: (person.get 'names').map (name) ->
							name.get '_id'

	.get '/names/:id', (req, res) ->
		database.name.findOne
			_id: req.params.id
		, (error, item) ->
			throw error if error?

			((new Name).FromDatabase item).then (name) ->
				res.send
					name:
						id: name.get '_id'
						title: name.get 'title'
						given: name.get 'given'
						surname: name.get 'surname'
						type: name.get 'type._id'
						origin: name.get 'origin._id'

	.get '/nametypes', (req, res) ->
		database.nametype.find {}, (error, items) ->
			throw error if error?
			res.send
				nametypes: items.map (item) ->
					id: item._id
					title: item.title

	.get '/nametypes/:id', (req, res) ->
		database.nametype.findOne
			_id: req.params.id
		, (error, item) ->
			throw error if error?
			res.send
				nametype:
					id: item._id
					title: item.title

	.get '/nameorigins', (req, res) ->
		database.nameorigin.find {}, (error, items) ->
			throw error if error?
			res.send
				nameorigins: items.map (item) ->
					id: item._id
					title: item.title

	.get '/nameorigins/:id', (req, res) ->
		database.nameorigin.findOne
			_id: req.params.id
		, (error, item) ->
			throw error if error?
			res.send
				nameorigin:
					id: item._id
					title: item.title

	.get '/genders', (req, res) ->
		database.gender.find {}, (error, items) ->
			throw error if error?
			res.send
				genders: items.map (item) ->
					id: item._id
					title: item.title

	.get '/genders/:id', (req, res) ->
		database.gender.findOne
			_id: req.params.id
		, (error, item) ->
			throw error if error?
			res.send
				gender:
					id: item._id
					title: item.title
	.listen 8000

console.log 'Running on localhost:8000...'
