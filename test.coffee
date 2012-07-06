with_base_params =
	settings:
		views: './test_templates'
tests =
	'Literal text':
    template: "text 'Just text'"
    expected: 'Just text'

  'Default DOCTYPE':
    template: "doctype()"
    expected: '<!DOCTYPE html>'

  'DOCTYPE':
    template: "doctype 'xml'"
    expected: '<?xml version="1.0" encoding="utf-8" ?>'

  'Custom tag':
    template: "tag 'custom'"
    expected: '<custom></custom>'

  'Custom tag with attributes':
    template: "tag 'custom', foo: 'bar', ping: 'pong'"
    expected: '<custom foo="bar" ping="pong"></custom>'

  'Custom tag with attributes and inner content':
    template: "tag 'custom', foo: 'bar', ping: 'pong', -> 'zag'"
    expected: '<custom foo="bar" ping="pong">zag</custom>'

  'Self-closing tags':
    template: "img src: 'icon.png', alt: 'Icon'"
    expected: '<img src="icon.png" alt="Icon" />'

  'Common tag':
    template: "p 'hi'"
    expected: '<p>hi</p>'

  'Attributes':
    template: "a href: '/', title: 'Home'"
    expected: '<a href="/" title="Home"></a>'

  'HereDocs':
    template: '''
      script """
        $(document).ready(function(){
          alert('test');
        });
      """
    '''
    expected: "<script>$(document).ready(function(){\n  alert('test');\n});</script>"

  'CoffeeScript helper (function)':
    template: "coffeescript -> alert 'hi'"
    expected: "<script>var __slice = Array.prototype.slice;var __hasProp = Object.prototype.hasOwnProperty;var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };var __extends = function(child, parent) {  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }  function ctor() { this.constructor = child; }  ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype;  return child; };var __indexOf = Array.prototype.indexOf || function(item) {  for (var i = 0, l = this.length; i < l; i++) {    if (this[i] === item) return i;  } return -1; };(function () {\n  return alert('hi');\n}).call(this);</script>"

  'CoffeeScript helper (string)':
    template: "coffeescript \"alert 'hi'\""
    expected: "<script type=\"text/coffeescript\">alert 'hi'</script>"

  'CoffeeScript helper (object)':
    template: "coffeescript src: 'script.coffee'"
    expected: "<script src=\"script.coffee\" type=\"text/coffeescript\"></script>"

  'Context vars':
    template: "h1 @foo"
    expected: '<h1>bar</h1>'
    params: {foo: 'bar'}

  'Local vars':
    template: 'h1 "dynamic: " + obj.foo'
    run: ->
      obj = {foo: 'bar'}
      @expected = '<h1>dynamic: bar</h1>'
      @result = render(@template, locals: {obj: obj})
      @success = @result is @expected
      if @success
        obj.foo = 'baz'
        @expected = '<h1>dynamic: baz</h1>'
        @result = render(@template, locals: {obj: obj})
        @success = @result is @expected

  'Comments':
    template: "comment 'Comment'"
    expected: '<!--Comment-->'

  'Escaping':
    template: "h1 h(\"<script>alert('\\\"pwned\\\" by c&a &copy;')</script>\")"
    expected: "<h1>&lt;script&gt;alert('&quot;pwned&quot; by c&amp;a &amp;copy;')&lt;/script&gt;</h1>"

  'Autoescaping':
    template: "h1 \"<script>alert('\\\"pwned\\\" by c&a &copy;')</script>\""
    expected: "<h1>&lt;script&gt;alert('&quot;pwned&quot; by c&amp;a &amp;copy;')&lt;/script&gt;</h1>"
    params: {autoescape: yes}

  'ID/class shortcut (combo)':
    template: "div '#myid.myclass1.myclass2', 'foo'"
    expected: '<div id="myid" class="myclass1 myclass2">foo</div>'

  'ID/class shortcut (ID only)':
    template: "div '#myid', 'foo'"
    expected: '<div id="myid">foo</div>'

  'ID/class shortcut (one class only)':
    template: "div '.myclass', 'foo'"
    expected: '<div class="myclass">foo</div>'

  'ID/class shortcut (multiple classes)':
    template: "div '.myclass.myclass2.myclass3', 'foo'"
    expected: '<div class="myclass myclass2 myclass3">foo</div>'

  'ID/class shortcut (no string contents)':
    template: "img '#myid.myclass', src: '/pic.png'"
    expected: '<img id="myid" class="myclass" src="/pic.png" />'

  'Attribute values':
    template: "br vrai: yes, faux: no, undef: @foo, nil: null, str: 'str', num: 42, arr: [1, 2, 3], obj: {foo: 'bar'}, func: ->"
    expected: '<br vrai="vrai" str="str" num="42" arr="1,2,3" obj-foo="bar" func="(function () {}).call(this);" />'

  'IE conditionals':
    template: """
      html ->
        head ->
          title 'test'
          ie 'gte IE8', ->
            link href: 'ie.css', rel: 'stylesheet'
    """
    expected: '''
      <html>
        <head>
          <title>test</title>
          <!--[if gte IE8]>
            <link href="ie.css" rel="stylesheet" />
          <![endif]-->
        </head>
      </html>

    '''
    params: {format: yes}

  'cede':
    template: "p \"This text could use \#{cede -> strong -> a href: '/', 'a link'}.\""
    expected: '<p>This text could use <strong><a href="/">a link</a></strong>.</p>'

	'Template function':
		template: ->
			h1 class: "main", -> "A Header"
			div -> p -> "Some text"
		expected: '<h1 class="main">A Header</h1><div><p>Some text</p></div>'

	'Expected throws, "integer" template':
		template: 87
		expects_exception: true

	'Expected throws, bad template':
		template: 'looks_like_a_file.coffee'
		expects_exception: true

	'Expected throws, template file not found':
		template: 'test_templates/non_existing_file.coffee'
		expects_exception: true

	'Template file':
		template: 'test_templates/simple.coffee'
		expected: '<html><head></head><body><h3>Hi there</h3></body></html>'

	'Template file with blocks':
		template: 'test_templates/base.coffee'
		expected: '<p>Base template</p><p class="base">Base\'s main block</p>'

	'Template file with base, no blocks':
		template: 'test_templates/sub_no_blocks.coffee'
		expected: '<p>Base template</p><p class="base">Base\'s main block</p>'
		params: with_base_params

	'Template file with base, fill extra block':
		template: 'test_templates/sub_extra.coffee'
		expected: '<p>Base template</p><p class="base">Base\'s main block</p><b>Extra!</b>'
		params: with_base_params

	'Template file with base, fill all blocks':
		template: 'test_templates/sub_all.coffee'
		expected: '<p>Base template</p><h1>Sub for the win!</h1>And the extra too'
		params: with_base_params

cf = require './src/coffeefilter'
render = cf.render
TemplateCompilationError = cf.TemplateCompilationError

@run = ->
	{print} = require 'sys'

	colors = {red: "\u001b[31m", redder: "\u001b[91m", green: "\u001b[32m", normal: "\u001b[0m"}
	printc = (color, str) -> print colors[color] + str + colors.normal

	[total, passed, failed, errors] = [0, [], [], []]

	pass_test = (name, test) ->
		passed.push name
		print "[Passed] #{name}\n"
	fail_test = (name, test) ->
		failed.push name
		printc 'red', "[Failed] #{name}\n"
	error_test = (name, test, ex) ->
		test.result = ex
		errors.push name
		printc 'redder', "[Error]  #{name}\n"

	for name, test of tests
		total++
		try
			test.original_params = JSON.stringify test.params

			if test.run
				test.run()
			else
				test.result = cf.render test.template, test.params
				test.success = test.result is test.expected

			if test.success
				pass_test name, test
			else
				fail_test name, test
		catch ex
			if test.expects_exception?
				test.result = ex
				pass_test name, test
			else
				error_test name, test, ex

	print "\n#{total} tests, #{passed.length} passed, #{failed.length} failed, #{errors.length} errors\n\n"

	if failed.length > 0
		printc 'red', "FAILED:\n\n"

		for name in failed
			t = tests[name]
			print "- #{name}:\n"
			print t.template + "\n"
			print t.original_params + "\n" if t.params
			printc 'green', "Expected:\n"
			printc 'green', t.expected + "\n"
			printc 'red',   "Actual:\n"
			printc 'red',   t.result + "\n\n"

	if errors.length > 0
		printc 'redder', "ERRORS:\n\n"

		for name in errors
			t = tests[name]
			print "- #{name}:\n"
			print t.template + "\n"
			printc 'green', t.expected + "\n"
			printc 'redder', t.result.stack + "\n\n"
