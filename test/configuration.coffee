cf = require '../lib/coffeefilter'
assert = require 'assert'

saved_settings = {}

backup_settings = ->
	for key, value of cf.settings
		saved_settings[key] = value

restore_settings = ->
	cf.configure saved_settings


suite 'configuration', ->
	test 'calling configure', ->
		backup_settings()

		for x in ['cache', 'datetime_function', 'date_format', 'datetime_format', 'time_format']
			arg = {}
			arg[x] = -1
			cf.configure arg
			assert.equal cf.settings[x], -1

		restore_settings()

suite 'date, datetime, time', ->
	test 'date, default function', ->
		t = -> render_date "2012-08-09"
		assert.equal (cf.render t), '2012-08-09'

		t = -> text parse_date "2012-08-09"
		assert.equal (cf.render t), '2012-08-09'

	test 'datetime, default function', ->
		t = -> render_datetime "2012-08-09"
		assert.equal (cf.render t), '2012-08-09'

		t = -> text parse_datetime "2012-08-09"
		assert.equal (cf.render t), '2012-08-09'

	test 'time, default function', ->
		t = -> render_time "2012-08-09"
		assert.equal (cf.render t), '2012-08-09'

		t = -> text parse_time "2012-08-09"
		assert.equal (cf.render t), '2012-08-09'

	test 'date, datetime, time, custom function', ->
		backup_settings()

		cf.configure datetime_function: (d, format, type) ->
			return "#{d} #{format} #{type}"

		t = ->
			render_date "date1", "f1"
			text parse_date "date2", "f2"
			render_datetime "datetime1", "f3"
			text parse_datetime "datetime2", "f4"
			render_time "time1", "f5"
			text parse_time "time2", "f6"

		assert.equal (cf.render t),
			['date1 f1 date', 'date2 f2 date',
			 'datetime1 f3 datetime', 'datetime2 f4 datetime',
			 'time1 f5 time', 'time2 f6 time'].join ''

		restore_settings()

	test 'date, datetime, time, default formats', ->
		backup_settings()

		cf.configure datetime_function: (d, format, type) ->
			return format

		format_assert = (t, format, f) ->
			assert.equal (cf.render t), f + f


		for ftype in ['date', 'datetime', 'time']
			t =
				"render_#{ftype} 'asdf'\ntext parse_#{ftype} 'fdas'"
			format = "#{ftype}_format"

			format_assert t, format, cf.settings[format]

			arg = {}
			arg[format] = format
			cf.configure arg
			format_assert t, format, format

		restore_settings()
