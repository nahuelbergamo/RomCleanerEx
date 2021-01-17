extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_OpenFile_pressed():
	$FileDialog.popup()

func _on_SaveFile_pressed():
	$SaveFileDialog.popup()

func _on_FileDialog_file_selected(path):
	print(path)
	var file = File.new()
	file.open(path,1)
	$TextEdit.text = file.get_as_text()
	file.close()

func _on_SaveFileDialog_file_selected(path):
	print(path)
	var file = File.new()
	file.open(path,2)
	file.store_string($TextEdit.text)
	file.close()
