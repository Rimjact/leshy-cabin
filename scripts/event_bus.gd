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
## Вызывается, когда карточка была выделеная среди остальных
signal card_hover_started(card: CardBase)
## Вызывается, когда выделение карточки среди остальных остановлено
signal card_hover_stopped(card: CardBase)
## Вызывается, когда позиция карточки в руке игрока обновлена 
signal card_in_player_deck_position_updated(card: CardBase, index: int, cards_count: int)

## Вызывается, когда количество карт в руке игрока обновлено
signal player_cards_in_hand_count_changed(card: CardBase)
