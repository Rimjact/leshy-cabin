class_name CardNameLabel
extends Label
## Подпись имени карточки. Длинные названия переносит и уменьшает, чтобы они оставались на спрайте.


## Сколько символов кириллицы помещается в плашку имени на базовом размере шрифта.
const MAX_LINE_CHARACTERS := 8
## Межстрочный интервал, когда имя занимает больше одной строки.
const WRAPPED_LINE_SPACING := -12

var _base_settings: LabelSettings
var _fitted_settings: LabelSettings
var _base_font_size: int = 36
var _base_line_spacing: float = 0.0
var _authored_height: float = 48.0
var _bounds_captured: bool = false


func _ready() -> void:
	_capture_layout()
	apply_display_name(text)


## Ставит имя карточки: переносит по словам и дефису и подбирает размер шрифта.
func apply_display_name(display_name: String) -> void:
	_capture_layout()
	var lines := split_display_name(display_name)
	autowrap_mode = TextServer.AUTOWRAP_OFF
	text = "\n".join(lines)
	_apply_font_size(lines)
	_apply_bounds(lines.size())


## Делит имя на строки по пробелам и дефисам. Дефис остаётся в конце верхней строки.
static func split_display_name(display_name: String) -> PackedStringArray:
	var lines := PackedStringArray()
	var current := ""
	var source := display_name.strip_edges()
	
	for index in source.length():
		var character := source[index]
		if character == " " or character == "\n":
			_append_line(lines, current)
			current = ""
			continue
		
		current += character
		if character == "-":
			_append_line(lines, current)
			current = ""
	
	_append_line(lines, current)
	if lines.is_empty():
		lines.append("")
	
	return lines


## Размер шрифта, при котором самая длинная строка не шире восьми символов базового кегля.
static func fitted_font_size(lines: PackedStringArray, base_font_size: int) -> int:
	var longest := 0
	for line in lines:
		longest = maxi(longest, line.length())
	
	if longest <= MAX_LINE_CHARACTERS or base_font_size <= 0:
		return base_font_size
	
	return maxi(1, int(float(base_font_size * MAX_LINE_CHARACTERS) / float(longest)))


func _capture_layout() -> void:
	if _base_settings == null and label_settings != null:
		_base_settings = label_settings
		_fitted_settings = label_settings.duplicate() as LabelSettings
		_base_font_size = _base_settings.font_size
		_base_line_spacing = _base_settings.line_spacing
	
	if _bounds_captured:
		return
	
	_authored_height = size.y
	_bounds_captured = true


func _apply_font_size(lines: PackedStringArray) -> void:
	if _fitted_settings == null:
		return
	
	var line_count := lines.size()
	var font_size := fitted_font_size(lines, _base_font_size)
	if line_count > 1:
		font_size = _font_size_fitting_height(font_size, line_count)
		_fitted_settings.line_spacing = WRAPPED_LINE_SPACING
	else:
		_fitted_settings.line_spacing = _base_line_spacing
	
	_fitted_settings.font_size = font_size
	label_settings = _fitted_settings


func _apply_bounds(_line_count: int) -> void:
	offset_bottom = offset_top + _authored_height
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER


## Уменьшает кегль, пока обе строки вместе с отрицательным интервалом помещаются в плашку.
func _font_size_fitting_height(font_size: int, line_count: int) -> int:
	var font := get_theme_font(&"font")
	if font == null:
		return font_size
	
	var f_size := font_size
	while f_size > 1 and text_block_height(font, f_size, line_count) > _authored_height:
		f_size -= 1
	
	return f_size


## Высота блока строк: кегль плюс межстрочный интервал переноса.
static func text_block_height(font: Font, font_size: int, line_count: int) -> float:
	var line_height := font.get_height(font_size)
	if line_count <= 1:
		return line_height
	
	return line_height * float(line_count) + float(WRAPPED_LINE_SPACING) * float(line_count - 1)


static func _append_line(lines: PackedStringArray, line: String) -> void:
	if line.is_empty():
		return
	
	lines.append(line)
