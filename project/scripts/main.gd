extends Node2D

var mode = "nutrient"
var NPK = [20,0,0]
var nutrient = 20
var unit = 1
var part = 1
var result

func _ready():
	pass

func _on_calculate_button_up():
	if !$split/left/input/nutrient.text.contains("actual"):
		nutrient = NPK[$split/left/input/nutrient.selected]
	elif $split/left/input/nutrient.text == "Phosphorous (actual)":
		nutrient = NPK[1]
		part = 0.44
	elif $split/left/input/nutrient.text == "Potassium (actual)":
		nutrient = NPK[2]
		part = 0.83
	unit = _getConversion($split/left/input/unitIn.text,$split/left/input/unitOut.text)
	if mode == "nutrient":
		if !$split/left/input/nutrient.text.contains("actual"):
			_nutrient($split/left/input/number.value,nutrient,unit)
		else: _nutrientActual($split/left/input/number.value,nutrient,unit,part)
		result = snapped(result,0.01)
		$split/left/result.text = str(result) + " " + str($split/left/input/unitOut.text) + " " + str($split/left/input/nutrient.text)
	else: 
		if !$split/left/input/nutrient.text.contains("actual"):
			_material($split/left/input/number.value,nutrient,unit)
		else: _materialActual($split/left/input/number.value,nutrient,unit,part)
		result = snapped(result,0.01)
		$split/left/result.text = str(result) + " " + str($split/left/input/unitOut.text) + " " + str($split/left/input/material.text)
	$split/right/history.text += $split/left/result.text + "\n"

func _on_switch_button_up():
	if $split/left/input/switch.text == "Mode: Material to Nutrient":
		$split/left/input/switch.text = "Mode: Nutrient to Material"
		mode = "material"
		$split/left/input.move_child($split/left/input/nutrient,2)
	else:
		$split/left/input/switch.text = "Mode: Material to Nutrient"
		mode = "nutrient"
		$split/left/input.move_child($split/left/input/material,2)

func _getConversion(unitIn,unitOut):
	if unitIn == unitOut:
		return 1
	else:
		match unitIn:
			"oz":
				match unitOut:
					"lb": return 0.0625
					"g": return 28.35
					"kg": return 0.0284
			"lb":
				match unitOut:
					"oz": return 16
					"g": return 454
					"kg": return 0.454
			"g":
				match unitOut:
					"oz": return 0.035
					"lb": return 0.002
					"kg": return 0.001
			"kg":
				match unitOut:
					"oz": return 35.27
					"lb": return 2.2
					"g": return 1000

func _nutrient(num,rat,con):
	if rat != 0: result = num * rat * con / float(100)
	else: result = 0

func _nutrientActual(num,rat,con,par):
	if rat != 0: result = num * rat * con / float(100) * par
	else: result = 0

func _material(num,rat,con):
	if rat != 0: result = num / rat * con * 100
	else: result = 0

func _materialActual(num,rat,con,par):
	if rat != 0: result = num / rat * con * 100 / float(par)
	else: result = 0


func _on_material_item_selected(index):
	match $split/left/input/material.get_item_text(index):
		"Ammonium sulfate":
			NPK = [20,0,0]
		"Ammonium nitrate":
			NPK = [33,0,0]
		"Diammonium phosphate":
			NPK = [18,46,0]
		"Sodium nitrate":
			NPK = [15,0,0]
		"Potassium nitrate":
			NPK = [13,0,44]
		"Superphosphate":
			NPK = [0,20,0]
		"Triple Superphosphate":
			NPK = [0,40,0]
		"Dicalcium phosphate":
			NPK = [0,52,0]
		"Diammonium phosphate":
			NPK = [18,46,0]
		"Monoammonium phosphate":
			NPK = [11,48,0]
		"Potassium chloride":
			NPK = [0,0,60]
		"Potassium nitrate":
			NPK = [13,0,44]
		"Bat guano":
			NPK = [10,2,1.7]
		"Blood meal":
			NPK = [14,0.7,0.7]
		"Cow manure":
			NPK = [2,1,2]
		"Compost":
			NPK = [2,1,1]
		"Fish meal":
			NPK = [10,2.6,0]
		"Poultry litter":
			NPK = [4.3,1.6,1.6]
		"Seaweed":
			NPK = [0.6,0,1.1]
		"Wood ashes":
			NPK = [0,0.9,5.6]
		_:
			NPK = [0,0,0]
	$split/left/input/material.tooltip_text = str(NPK[0]) + "-" + str(NPK[1]) + "-" + str(NPK[2])
