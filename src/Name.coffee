'use strict'

require 'ember/runtime'

module.exports = Ember.Object.extend

	first: ''
	last: ''

	full: (->
		first = @get 'first'
		last = @get 'last'
		"#{first} #{last}"
	).property 'first', 'last'
