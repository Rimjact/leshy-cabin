extends Node
## Глобальный скрипт шины событий


## Вызывается, когда курсор навёлся на карточку
signal card_cursor_entered(card: CardBase)
## Вызывается, когда курсор ушёл с карточки
signal card_cursor_exited(card: CardBase)
## Вызывается, когда произошел левый клик по карточку
signal card_cursor_left_button_clicked(card: CardBase)
## Вызывается, когда произошел правый клик по карточке
signal card_cursor_right_button_clicked(card: CardBase)
