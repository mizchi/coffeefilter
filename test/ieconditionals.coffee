cf = require '../lib/coffeefilter'
assert = require 'assert'

suite 'ie conditionals', ->
	test 'conditional', ->
		t = ->
      html ->
        head ->
          title 'test'
          ie 'gte IE8', ->
            link href: 'ie.css', rel: 'stylesheet'
		e = '''
      <html>
        <head>
          <title>test</title>
          <!--[if gte IE8]>
            <link href="ie.css" rel="stylesheet" />
          <![endif]-->
        </head>
      </html>

    '''
		assert.equal (cf.render t, format: yes), e
