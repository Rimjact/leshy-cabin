@abstract
class_name GameLoggerHandler
## Абстрактный класс обработчика сообщений логгера


## Форматтер сообщений
var _formatter: GameLoggerFormatter


func _init() -> void:
	_set_default_formatter()


@abstract
## Обрабатывает сообщение логгера
func handle_message(message: LoggingMessage) -> void


## Устанавливет форматы сообщения и даты
func set_formatter(date_fmt: String, msg_fmt: String) -> void:
	_formatter = GameLoggerFormatter.new(date_fmt, msg_fmt)


## Устанавливает формат даты и сообщения по умолчанию
func _set_default_formatter() -> void:
	var date_format := "{d}.{m}.{y} {H}:{M}:{S}"
	var msg_format := "{date} - {loggername} - {levelname} - {text}"
	set_formatter(date_format, msg_format)
