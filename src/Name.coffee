'use strict'

require 'ember/runtime'

module.exports = Ember.Object.extend

	id: ''
	title: ''
	given: ''
	surname: ''
	type: ''

	full: (->
		names = [
			@get 'title'
			@get 'given'
			@get 'surname'
		].filter (item) ->
			item isnt ''
		.join ' '
	).property 'title', 'given', 'surname'
