'use strict'

GLOBAL.window =
    console: console

Person = require './Person.js'

p = new Person
console.log p.get 'full'
