class_name LoggingMessage
## Класс сообщения лога


## Дата и время отправки сообщения
var date: Dictionary
## Имя логгера с которого отправлено сообщение
var logger_name: String
## Уровень лога
var level_name: String
## Текс сообщения
var text: String


func _init(cur_date: Dictionary, lgr_name: String, lvl_name: String, txt: String) -> void:
	date = cur_date
	logger_name = lgr_name
	level_name = lvl_name
	text = txt
