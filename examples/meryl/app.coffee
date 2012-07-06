meryl = require 'meryl'
coffeefilter = require '../../src/coffeefilter'

meryl.h 'GET /', (req, resp) ->
  people = ['bob', 'alice', 'meryl']
  resp.render 'layout', content: 'index', context: {people: people}

meryl.run
  templateDir: 'templates'
  templateExt: '.coffee'
  templateFunc: coffeefilter.adapters.meryl

console.log 'Listening on 3000...'
