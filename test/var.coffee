cf = require '../lib/coffeefilter'
assert = require 'assert'

suite 'vars', ->
	test 'context vars', ->
		t = -> p @hamlet
		assert.equal (cf.render t, hamlet: 'shakespeare'), '<p>shakespeare</p>'

	test 'locals as parameters', ->
		t = ->
			h1 -> title
			p -> content
		assert.equal (cf.render t, locals: {title: "Foo", content: "Bar"}),
			'<h1>Foo</h1><p>Bar</p>'
