'use strict'

module.exports = window.App.Person = DS.Model.extend

	names: DS.hasMany 'name',
		async: true

	name: DS.belongsTo 'name',
		async: true

	gender: DS.belongsTo 'gender',
		async: true

	display: (->
		[
			@get 'name.full'
			switch @get 'gender.title'
				when 'MALE'   then '♂'
				when 'FEMALE' then '♀'
				else @get 'gender.title'
		].filter (item) ->
			item? and item.toLowerCase() isnt 'unknown'
		.join ' '
	).property 'name.full', 'gender.title'

	FromDatabase: (options={}) ->
		@set key, value for key, value of options

		deferred = q.defer()
		setImmediate =>
			(q.all [
				@SetName @get 'name'
				@SetNames @get 'names'
				@SetGender @get 'gender'
			]).then =>
				deferred.resolve @
		deferred.promise

	SetNames: (ids) ->
		deferred = q.defer()
		setImmediate =>

			@set 'names', []
			database.name.find
				$or: ids.map (id) ->
					_id: id
			, (error, items) =>
				return deferred.reject error if error?
				(q.all items.map (item) =>
					inner = q.defer()
					setImmediate =>
						((new Name).FromDatabase item).then (name) =>
							@names.push name
							inner.resolve()
					inner.promise
				).then => deferred.resolve @

		deferred.promise

	SetName: (id) ->
		deferred = q.defer()
		setImmediate =>
			return deferred.resolve @ unless id?
			database.name.findOne
				_id: id
			, (error, item) =>
				return deferred.reject error if error?
				@set 'name', Name.create item
				deferred.resolve @
		deferred.promise

	SetGender: (id) ->
		deferred = q.defer()
		setImmediate =>
			return deferred.resolve @ unless id?
			database.gender.findOne
				_id: id
			, (error, item) =>
				return deferred.reject error if error?
				@set 'gender', Gender.create item
				deferred.resolve @
		deferred.promise
