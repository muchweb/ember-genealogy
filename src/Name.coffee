'use strict'

require 'ember/runtime'
Nametype = require './Nametype.js'

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
		database.nametype.findOne
			_id: data.type
		, (error, item) =>
			throw error if error?
			@set 'type', Nametype.create item
			callback @
