class_name Logging
## Класс отвечающий за работу с игровым логгером


## Возвращает новый <code>GameLogger</code>
static func create_logger(name: String) -> GameLogger:
	var logger := GameLogger.new(name)
	return logger


## Возвращает новый <code>GameLoggerHandlerConsole</code>
static func create_console_handler() -> GameLoggerHandlerConsole:
	var handler := GameLoggerHandlerConsole.new()
	return handler


## Возвращяет новый GameLoggerHandlerFile
static func create_file_handler() -> GameLoggerHandlerFile:
	var handler := GameLoggerHandlerFile.new()
	return handler
