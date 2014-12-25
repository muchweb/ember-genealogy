'use strict'

require 'ember/runtime'
Name = require './Name.js'

module.exports = Ember.Object.extend

	names: []

	FromDatabase: (data, callback) ->
		database.name.find
			$or: data.names.map (id) ->
				_id: id
		, (error, items) =>
			for item in items
				(new Name).FromDatabase item, (item) =>
					@names.push item
					callback @
