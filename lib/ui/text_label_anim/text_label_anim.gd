class_name TextLabelAnim extends RichTextLabel

signal anim_finished

var NUMS = [
	"4354076982764985762487698756983276459876458745",
	"9548764307598769640698564359876249826498376598",
	"3847650110249287326987634444876587360908743658"]
var stagger = [5, 4, 3, 2, 1]
const FTIME = 0.05
var transitioning
var current_place = 0

func animate(get_text):
	if transitioning == true: return
	
	transitioning = true
	var out_text
	var c = get_text
	for N in NUMS:
		out_text = ""
		while len(c) > len(N) - 1: N += N
		for i in range(0, len(c)):
			if c[i] != " ": out_text += N[i]
			else: out_text += " "
		text = out_text
		await get_tree().create_timer(FTIME).timeout
	for m in stagger:
		for i in range(0, len(c)):
			if i % m == 0: out_text[i] = c[i]
			text = out_text
		await get_tree().create_timer(FTIME).timeout
	
	text = c
	current_place += 1
	transitioning = false
	anim_finished.emit()
