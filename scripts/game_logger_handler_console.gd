class_name GameLoggerHandlerConsole
extends GameLoggerHandler
## Класс обработчика сообщений логгера с выводом в консоль


func handle_message(message: LoggingMessage) -> void:
	var formatted_message: String = _formatter.format_message(message)
	
	match message.level_name:
		"DEBUG":
			print_debug(formatted_message)
		"INFO":
			print(formatted_message)
		"WARNING":
			push_warning(formatted_message)
		"ERROR":
			push_error(formatted_message)
