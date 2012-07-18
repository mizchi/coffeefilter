extend 'base'

block 'extra', ->
	p "extra block"
	block 'new-block', ->
		p "new block"
