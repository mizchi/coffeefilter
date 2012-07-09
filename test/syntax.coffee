cf = require '../lib/coffeefilter'
assert = require 'assert'

suite 'syntax', ->
	test 'literal text', ->
		t = 'text "wohooo"'
		assert.equal (cf.render t), 'wohooo'

	test 'function template, literal text', ->
		t = -> text "buffy"
		assert.equal (cf.render t), 'buffy'

	test 'simple literal text does nothing', ->
		t = '"wohooo"'
		assert.equal (cf.render t), ''

	test 'cede', ->
		t = -> p "This text could use #{cede -> strong -> a href: '/', 'a link'}."
		assert.equal (cf.render t), '<p>This text could use <strong><a href="/">a link</a></strong>.</p>'

	test 'escaping', ->
		t = -> h1 h("<script>alert('\\\"attempted\\\" html injection, c&a, &copy;')</script>")
		assert.equal (cf.render t),
			"<h1>&lt;script&gt;alert('\\&quot;attempted\\&quot; html injection, c&amp;a, &amp;copy;')&lt;/script&gt;</h1>"

	test 'auto escaping', ->
		t = -> h1 "<script>alert('\\\"attempted\\\" html injection, c&a, &copy;')</script>"
		assert.equal (cf.render t, autoescape: true),
			"<h1>&lt;script&gt;alert('\\&quot;attempted\\&quot; html injection, c&amp;a, &amp;copy;')&lt;/script&gt;</h1>"

	test 'html comments', ->
		t = -> comment 'the wizard and I'
		assert.equal (cf.render t), '<!--the wizard and I-->'

	test 'coffeescript comments', ->
		t = ->
			p 'some text'
			# a comment
			p 'more text'
		assert.equal (cf.render t), '<p>some text</p><p>more text</p>'

	test 'heredocs', ->
		t = '''
script """
$(document).ready(function(){
	alert('test');
});
"""
		'''
		assert.equal (cf.render t), "<script>$(document).ready(function(){\n	alert('test');\n});</script>"
