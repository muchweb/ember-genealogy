'use strict'

window[key] = value for key, value of module.exports

window.App = Ember.Application.create()

window.App.ApplicationStore = DS.Store.extend()
window.App.ApplicationAdapter = DS.RESTAdapter.extend()

window.App.Router.map ->
	@route 'about'
	@route 'people'

window.App.PeopleRoute = window.Ember.Route.extend
	model: ->
		@store.find 'person'
