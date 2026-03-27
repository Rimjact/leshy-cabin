class_name GameLoggerHandlerFile
extends GameLoggerHandler
## Класс обработчика сообщений логгера с записью в файл


func handle_message(message: LoggingMessage) -> void:
	var formatted_message: String = _formatter.format_message(message)
	
	const file_path: String = Global.LOG_FILE_PATH
	
	var log_file: FileAccess
	
	if not FileAccess.file_exists(file_path):
		log_file = FileAccess.open(file_path, FileAccess.WRITE_READ)
		log_file.store_line(formatted_message)
		log_file.close()
		return

	log_file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	log_file.seek_end()
	log_file.store_line(formatted_message)
	log_file.close()
