'use strict'

window.App = Ember.Application.create()

window.App.Store = DS.Store.extend {}
window.App.ApplicationAdapter = DS.RESTAdapter.extend {}

window.App.Router.map ->
	@route 'about'
