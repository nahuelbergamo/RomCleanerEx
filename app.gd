extends Control

var read_dir = ''
var write_dir = ''

# Region
var usa = 0
var europe = 0
var japan = 0
var asia = 0
# Licensed?
var unlicensed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Menu Items
	for i in ['Open Roms Folder','Save Copies to Folder','Quit']:
		$MenuButtonFile.get_popup().add_item(i)
	for i in ['About','Github Repo']:
		$MenuButtonHelp.get_popup().add_item(i)
	# Signals
	$MenuButtonFile.get_popup().connect('id_pressed', self, '_on_item_pressed')
	$MenuButtonHelp.get_popup().connect('id_pressed', self, '_on_help_pressed')
	# Shortcuts
	$MenuButtonFile.get_popup().set_item_shortcut(2, set_shortcut(KEY_Q), true)

func set_shortcut(key):
	var shortcut = ShortCut.new()
	var inputeventkey = InputEventKey.new()
	inputeventkey.set_scancode(key)
	inputeventkey.control = true
	shortcut.set_shortcut(inputeventkey)
	return shortcut

func _on_item_pressed(id):
	var item_name = $MenuButtonFile.get_popup().get_item_text(id)
	match item_name:
		'Open Roms Folder':
			$FolderDialog.popup()
		'Save Copies to Folder':
			$SaveFilteredDialog.popup()
		'Quit':
			get_tree().quit()

func _on_help_pressed(id):
	var about_name = $MenuButtonHelp.get_popup().get_item_text(id)
	match about_name:
		'About':
			$AboutDialog.popup()
		'Github Repo':
			OS.shell_open('https://github.com/nahuelbergamo/RomCleanerEx')

# To choose an empty folder to copy the filtered roms to
func _on_SaveFilteredDialog_dir_selected(dir):
	print('copy the filtered roms to: ' + dir)
	write_dir = dir

# To choose a ROMs folder to filter
func _on_FolderDialog_dir_selected(dir):
	if $RomList != null:
		$RomList.clear()
	print('filter roms from: ' + dir)
	read_dir = dir
	var files = []
	var dir_aux = Directory.new()
	dir_aux.open(read_dir)
	dir_aux.list_dir_begin()
	while true:
		var file = dir_aux.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			$RomList.add_item(file.get_basename(),null,false)
			# Also sum up the stats vars
			if '(USA)' in file.get_basename():
				usa = usa + 1
	$StatsReportLabel.text = 'USA Games: ' + str(usa)
