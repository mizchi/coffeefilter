cf = require '../lib/coffeefilter'
assert = require 'assert'

suite 'id/class shortcuts', ->
	test 'custom tag', ->
		t = -> tag 'buffy', ''
		assert.equal (cf.render t), '<buffy></buffy>'

	test 'id only', ->
		t = -> div '#myid', ''
		assert.equal (cf.render t), '<div id="myid"></div>'

	test 'id and content', ->
		t = -> div '#myid', 'buffy'
		assert.equal (cf.render t), '<div id="myid">buffy</div>'

	test 'one class only', ->
		t = -> div '.cls1', ''
		assert.equal (cf.render t), '<div class="cls1"></div>'

	test 'one class and content', ->
		t = -> div '.cls1', 'vampire'
		assert.equal (cf.render t), '<div class="cls1">vampire</div>'

	test 'multiple classes', ->
		t = -> div '.addison.wesley-snipes.c', ''
		assert.equal (cf.render t), '<div class="addison wesley-snipes c"></div>'

	test 'combo', ->
		t = -> div '#parker.shadow.memory', ''
		assert.equal (cf.render t), '<div id="parker" class="shadow memory"></div>'

	test 'one argument is treated as content', ->
		t = -> div '#id.class'
		assert.equal (cf.render t), '<div>#id.class</div>'

	test 'id/class and other attributes works', ->
		t = -> img '#beethoven.bach', src: 'img.png'
		assert.equal (cf.render t), '<img id="beethoven" class="bach" src="img.png" />'
		t = -> a '#link.to.this', href: '#huh'
		assert.equal (cf.render t), '<a id="link" class="to this" href="#huh"></a>'
