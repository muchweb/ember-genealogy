'use strict'

require 'ember/runtime'
require 'ember/rsvp'
Nametype = require './Nametype.js'
q = require 'q'

module.exports = Ember.Object.extend

	id: ''
	title: ''
	given: ''
	surname: ''
	type: null

	full: (->
		names = [
			@get 'title'
			@get 'given'
			@get 'surname'
			@get 'type.title'
		].filter (item) ->
			item isnt ''
		.join ' '
	).property 'title', 'given', 'surname', 'type.title'

	FromDatabase: (data, callback) ->
		@set 'id', data.id
		@set 'title', data.title
		@set 'given', data.given
		@set 'surname', data.surname
		deferred = q.defer()
		setImmediate =>
			database.nametype.findOne
				_id: data.type
			, (error, item) =>
				throw error if error?
				@set 'type', Nametype.create item
				deferred.resolve @
		deferred.promise
