cf = require '../lib/coffeefilter'
assert = require 'assert'

tp = (path) ->
	"#{__dirname}/templates/#{path}"

render = (template) ->
	cf.render template, settings: { views: "#{__dirname}/templates"}

suite 'file template', ->
	test 'simple file template', ->
		t = tp 'simple.coffee'
		assert.equal (render t),
			'<html><head></head><body><h3>Hi there</h3></body></html>'

suite 'inheritance', ->
	test 'just blocks', ->
		t = tp 'base.coffee'
		assert.equal (render t),
			'<p>Base template</p><p class="base">Base\'s main block</p>'

	test 'sub template, no sub blocks', ->
		t = tp 'sub_no_blocks.coffee'
		assert.equal (render t),
			'<p>Base template</p><p class="base">Base\'s main block</p>'

	test 'sub template, fill one base block', ->
		t = tp 'sub_extra.coffee'
		assert.equal (render t),
			'<p>Base template</p><p class="base">Base\'s main block</p><b>Extra!</b>'

	test 'sub template, fill all blocks', ->
		t = tp 'sub_all.coffee'
		assert.equal (render t),
			'<p>Base template</p><h1>Sub for the win!</h1>And the extra too'

	test 'sub template, add new block', ->
		t = tp 'sub_new_block.coffee'
		assert.equal (render t),
			'<p>Base template</p><p class="base">Base\'s main block</p><p>extra block</p><p>new block</p>'

	test 'sub in sub in base', ->
		t = tp 'sub_sub.coffee'
		assert.equal (render t),
			'<p>Base template</p><h1>Sub for the win!</h1><p>sub sub extra!</p>'

	test 'block in block', ->
		t = tp 'block_in_block_base.coffee'
		assert.equal (render t),
			'<p>Rafael</p><p>Leonardo</p><p>Emile</p>'

	test 'block in block, sub', ->
		t = tp 'block_in_block_sub.coffee'
		assert.equal (render t),
			'<p>Rafael</p><p>Leonardo</p><p>Michelangelo</p>'

	test 'block in block, sub sub', ->
		t = tp 'block_in_block_sub_sub.coffee'
		assert.equal (render t),
			'<p>Rafael</p><p>Leonardo</p><p>Buffy</p>'

suite 'bad template arguments', ->
	test '"integer" template', ->
		t = 87
		assert.throws -> cf.render t

	test '"file look-a-like" template', ->
		t = 'this looks like a file, but isn\'t, function() {}, .coffee'
		assert.throws -> render t

	test 'non-existing file', ->
		t = tp 'non_existing_file.coffee'
		assert.throws -> render t
