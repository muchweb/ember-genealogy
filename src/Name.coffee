'use strict'

require 'ember/runtime'
require 'ember/rsvp'
Nametype = require './Nametype.js'
Nameorigin = require './Nameorigin.js'
q = require 'q'

module.exports = Ember.Object.extend

	id: ''
	title: ''
	given: ''
	surname: ''
	type: null
	origin: null

	full: (->
		[
			@get 'title'
			@get 'given'
			@get 'surname'
			if (@get 'type.title')? then "(#{@get 'type.title'})" else ''
			if (@get 'origin.title')? then "(#{@get 'origin.title'})" else ''
		].filter (item) ->
			item? and item isnt ''
		.join ' '
	).property 'title', 'given', 'surname', 'type.title', 'origin.title'

	FromDatabase: (data, callback) ->
		@set 'id', data.id
		@set 'title', data.title
		@set 'given', data.given
		@set 'surname', data.surname
		@set 'type', data.type
		@set 'origin', data.origin

		deferred = q.defer()
		setImmediate =>
			(q.all [
				@SetType @get 'type'
				@SetOrigin @get 'origin'
			]).then => deferred.resolve @
		deferred.promise

	SetType: (id) ->
		deferred = q.defer()
		setImmediate =>
			return deferred.resolve @ unless id?
			database.nametype.findOne
				_id: id
			, (error, item) =>
				return deferred.reject error if error?
				@set 'type', Nametype.create item
				deferred.resolve @
		deferred.promise

	SetOrigin: (id) ->
		deferred = q.defer()
		setImmediate =>
			return deferred.resolve @ unless id?
			database.nameorigin.findOne
				_id: id
			, (error, item) =>
				return deferred.reject error if error?
				@set 'origin', Nameorigin.create item
				deferred.resolve @
		deferred.promise
