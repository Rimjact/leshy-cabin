class_name GameLogger
## Класс игрового логгера.<br/>
## Позволяет выводить логи в консоль и отдельный .log файл используя
## соответствующие обработчики <code>GameLoggerHandler</code>.


## Имя логгера
var _name: String

## Массив обработчиков сообщений логгера
var _handlers: Array[GameLoggerHandler] = []


func _init(name: String) -> void:
	_name = name


## Добавляет новый обработчик в конец массива
func add_handler(handler: GameLoggerHandler) -> void:
	_handlers.append(handler)


## Убирает обработчик из массива
func remove_hanlder(handler: GameLoggerHandler) -> void:
	_handlers.erase(handler)


## Отправляет отладочное сообщение
func debug(text: String) -> void:
	_send_message_to_handlers("DEBUG", text)


## Отправляет информационное сообщение
func info(text: String) -> void:
	_send_message_to_handlers("INFO", text)


## Отправляет предупреждающее сообщение
func warning(text: String) -> void:
	_send_message_to_handlers("WARNING", text)


## Отправляет сообщение об ошибке
func error(text: String) -> void:
	_send_message_to_handlers("ERROR", text + "\n")


## Создаёт и пересылает сообщение обработчикам логгера
func _send_message_to_handlers(level_name: String, text: String) -> void:
	var cur_date := Time.get_datetime_dict_from_system()
	var message := LoggingMessage.new(cur_date, _name, level_name, text)
	
	for handler: GameLoggerHandler in _handlers:
		handler.handle_message(message)
