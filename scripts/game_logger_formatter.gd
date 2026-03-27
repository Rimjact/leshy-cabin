class_name GameLoggerFormatter
## Класс форматтера для обработчика сообщений логгера


## Формат вывода времени
var date_format: String
## Формат вывода сообщений
var message_format: String


func _init(date_fmt: String, msg_fmt: String) -> void:
	date_format = date_fmt
	message_format = msg_fmt


## Возвращает форматированную строку сообщения лога
func format_message(message: LoggingMessage) -> String:
	var formatted_date: String = _get_formatted_date(message.date)
	var format = {
		"date": formatted_date,
		"loggername": message.logger_name,
		"levelname": message.level_name,
		"text": message.text,
	}
	
	return message_format.format(format)


## Возвращает форматированную строку текущей даты и времени
func _get_formatted_date(date: Dictionary) -> String:
	var format = {
		"y": date.year,
		"m": date.month,
		"d": date.day,
		"H": date.hour,
		"M": date.minute,
		"S": date.second,
	}
	
	return date_format.format(format)
