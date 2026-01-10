extends Node
## Глобальный скрипт шины событий


######## CARD ########
## Вызывается, когда курсор навёлся на карточку
signal card_cursor_entered(card: CardBase)
## Вызывается, когда курсор ушёл с карточки
signal card_cursor_exited(card: CardBase)
## Вызывается, когда произошел левый клик по карточке
signal card_cursor_left_button_clicked(card: CardBase)
## Вызывается, когда произошел правый клик по карточке
signal card_cursor_right_button_clicked(card: CardBase)
## Вызывается, когда карточка была выделеная среди остальных
signal card_hover_started(card: CardBase)
## Вызывается, когда выделение карточки среди остальных остановлено
signal card_hover_stopped(card: CardBase)
## Вызывается, когда карточка выбрана
signal card_selected(card: CardBase)
## Вызывается, когда выбор карточки снят
signal card_deselected(card: CardBase)
## Вызывается, когда позиция карточки в руке игрока обновлена 
signal card_in_player_deck_position_updated(card: CardBase, index: int, cards_count: int)

######## SLOTS ########
## Вызывается, когда курсор навёлся на слот
signal slot_cursor_entered(slot: SlotBase)
## Вызывается, когда курсор ушёл со слота 
signal slot_cursor_exited(slot: SlotBase)
## Вызывается, когда произошел левый клик по слоту
signal slot_cursor_left_button_clicked(slot: SlotBase)
## Вызывается, когда произошел правый клик по слоту
signal slot_cursor_right_button_clicked(slot: SlotBase)

######## PLAYER CARDS CONTROLLER ########
## Вызывается, когда количество карт игрока обновлено
signal player_cards_count_changed(card: CardBase)
## Вызывается, когда игроку добавлена карточка
signal player_card_added(card: CardBase)
## Вызывается, когда у игрока убарна карточка
signal player_card_removed(card: CardBase)

######## DECK ########
## Вызывается, когда курсор наведён на колоду
signal deck_cursor_entered(deck: DeckBase)
## Вызывается, когда курсор ушёл с колоды
signal deck_cursor_exited(deck: DeckBase)
## Вызывается, когда произошел левый клик по колоде
signal deck_cursor_left_button_clicked(deck: DeckBase)
## Вызывается, когда произошел правый клик по колоде
signal deck_cursor_right_button_clicked(deck: DeckBase)
## Вызывается, когда начато заполнение колоды карточками
signal deck_fill_started(deck: DeckBase)
## Вызывается, когда заполнение колоды карточками закончено
signal deck_fill_completed(deck: DeckBase)
## Вызывается, когда количество карточек в колоде обновлено
signal deck_cards_count_updated(deck: DeckBase)
