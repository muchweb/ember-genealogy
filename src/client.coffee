'use strict'

window[key] = value for key, value of module.exports

window.App = Ember.Application.create()

window.App.ApplicationStore = DS.Store.extend()
window.App.ApplicationAdapter = DS.RESTAdapter.extend()

window.App.Router.map ->
	@route 'about'
	@route 'people'
	@route 'genders'
	@resource 'person', {
		path: '/person/:id'
	}, ->

window.App.GendersRoute = window.Ember.Route.extend
	model: ->
		@store.find 'gender'

	setupController: (controller, model) ->
		controller.set 'model', model

window.App.GendersController = window.Ember.ArrayController.extend()

window.App.PeopleRoute = window.Ember.Route.extend
	model: ->
		@store.find 'person'

	setupController: (controller, model) ->
		controller.set 'model', model

window.App.PeopleController = window.Ember.ArrayController.extend
	drink: 'tea'

	actions:
		Beep: ->
			alert 'hi'

window.App.PersonRoute = window.Ember.Route.extend
	model: (params) ->
		Ember.Object.create
			person: @store.find 'person', params.id
			genders: @store.find 'gender'

	setupController: (controller, model) ->
		controller.set 'model', model

window.App.PersonController = window.Ember.ObjectController.extend
	needs: [
		'genders'
	]

	actions:
		Beep: ->
			alert 'hi'
