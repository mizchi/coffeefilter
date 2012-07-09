cf = require '../lib/coffeefilter'
assert = require 'assert'

suite 'doctypes', ->
	test 'default', ->
		t = -> doctype()
		assert.equal (cf.render t), '<!DOCTYPE html>'

	test 'the other doctypes', ->
		for key of cf.doctypes
			t = "doctype '#{key}'"
			assert.equal (cf.render t), cf.doctypes[key]
