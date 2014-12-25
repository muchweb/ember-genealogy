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
	type: '-1'
	origin: '-1'

	full: (->
		[
			@get 'title'
			@get 'given'
			@get 'surname'
			if (@get 'type.title')? then "(#{@get 'type.title'})" else ''
			if (@get 'origin.title')? then "(#{@get 'origin.title'})" else ''
		].filter (item) ->
			item? and item isnt '' and item.toLowerCase() isnt '(unknown)'
		.join ' '
	).property 'title', 'given', 'surname', 'type.title', 'origin.title'

	FromDatabase: (options={}) ->
		@set key, value for key, value of options

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
