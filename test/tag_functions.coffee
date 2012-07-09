cf = require '../lib/coffeefilter'
assert = require 'assert'

suite 'tag functions', ->
	test 'custom tag', ->
		t = -> tag 'buffy'
		assert.equal (cf.render t), '<buffy></buffy>'

	test 'custom tag with attributes', ->
		t = -> tag 'buffy', que: 'huh?', num: 2
		assert.equal (cf.render t), '<buffy que="huh?" num="2"></buffy>'

	test 'custom tag with attributes and inner content', ->
		t = -> tag 'buffy', que: 'huh?', num: 2, 'the vampire slayer'
		assert.equal (cf.render t), '<buffy que="huh?" num="2">the vampire slayer</buffy>'

	test 'self-closing tags', ->
		t = -> img()
		assert.equal (cf.render t), '<img />'

	test 'self-closing tags with attributes', ->
		t = -> img src: 'path/to/image.png', alt: "Awesome picture!"
		assert.equal (cf.render t), '<img src="path/to/image.png" alt="Awesome picture!" />'

	test 'attributes', ->
		t = -> a href: "/home"
		assert.equal (cf.render t), '<a href="/home"></a>'
		t = -> a href: "/home", title: "Go Home"
		assert.equal (cf.render t), '<a href="/home" title="Go Home"></a>'
		t = -> a href: "/home", "asdf"
		assert.equal (cf.render t), '<a href="/home">asdf</a>'
		t = -> a href: "/home", title: "Go Home", "asdf"
		assert.equal (cf.render t), '<a href="/home" title="Go Home">asdf</a>'
		t = -> a href: "/home", -> "asdf"
		assert.equal (cf.render t), '<a href="/home">asdf</a>'

	test 'misc. attributes', ->
		t = -> br vrai: yes, faux: no, undef: @foo, nil: null, str: 'str', num: 42, arr: [1, 2, 3], obj: {foo: 'bar'}, func: ->
		assert.equal (cf.render t),
			'<br vrai="vrai" str="str" num="42" arr="1,2,3" obj-foo="bar" func="(function () {}).call(this);" />'

	test 'all tags', ->
		for tag in cf.tags
			t = "#{tag}()"
			if tag in cf.self_closing
				assert.equal (cf.render t), "<#{tag} />"
			else
				assert.equal (cf.render t), "<#{tag}></#{tag}>"
