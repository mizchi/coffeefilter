cf = require '../lib/coffeefilter'
assert = require 'assert'

suite 'coffeescript helpers', ->
	test 'function', ->
		remove_whitespace = (str) ->
			str = str.replace(/\n/g, ' ')
			str = str.replace(/\t/g, ' ')
			while (str2 = str.replace('  ', ' ')) != str
				str = str2
			return str
		t = -> coffeescript -> alert 'hi'
		helpers = """
	var __slice = Array.prototype.slice;
	var __hasProp = Object.prototype.hasOwnProperty;
	var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
	var __extends = function(child, parent) {
		for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
		function ctor() { this.constructor = child; }
		ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype;
		return child; };
	var __indexOf = Array.prototype.indexOf || function(item) {
		for (var i = 0, l = this.length; i < l; i++) {
			if (this[i] === item) return i;
		} return -1; };
""".replace(/\n/g, '').replace(/\t/g, ' ')
		code = """(function () { return alert('hi'); }).call(this);"""
		h = remove_whitespace (cf.render t)
		e = remove_whitespace ("<script>" + helpers + code + "</script>")
		assert.equal h, e

	test 'string', ->
		t = -> coffeescript "alert 'hi'"
		assert.equal (cf.render t), '<script type="text/coffeescript">alert \'hi\'</script>'

	test 'object', ->
		t = -> coffeescript src: 'script.coffee'
		assert.equal (cf.render t), '<script src="script.coffee" type="text/coffeescript"></script>'
