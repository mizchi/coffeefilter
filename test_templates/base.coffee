p "Base template"
block 'main', ->
	p class: "base", -> "Base's main block"
# extra block is empty, only seen if populated from sub-templates
block 'extra'
