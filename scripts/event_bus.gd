extends Node
## Шина событий.


## (Сигнал) Курсор навёлся на карточку.
signal card_cursor_entered(card: Card)
## (Сигнал) Курсор ушел от карточки.
signal card_cursor_exited(card: Card)
## (Сигнал) Курсор кликнул левой кнопкой мыши по карточке.
signal card_cursor_left_button_clicked(card: Card)
## (Сигнал) Курсор кликнул правой кнопкой мыши по карточке.
signal card_cursor_right_button_clicked(card: Card)
## (Сигнал) Карточка атакует.
signal card_attack(attack_info: AttackInfo)
## (Сигнал) Карточка атакована.
signal card_attacked(card: Card, attack_info: AttackInfo)
## (Сигнал) Карточка убита.
signal card_killed(card: Card, killer: Card)
## (Сигнал) Карточка вылечена.
signal card_healed(card: Card, healer: Card)
## (Сигнал) Здоровье карточки изменено.
signal card_health_changed(card: Card, old_value: int, new_value: int)


## (Сигнал) Курсор кликнул левой конопкой мыши по колоде.
signal deck_cursor_left_button_clicked(deck: PlayerDeck)
## (Сигнал) Курсор кликнул правой кнопкой мыши по колоде.
signal deck_cursor_right_button_clicked(deck: PlayerDeck)
## (Сигнал) Колода карточек заполнена.
signal deck_filled(deck: PlayerDeck)
## (Сигнал) Карточка взята из колоды.
signal deck_card_given(deck: PlayerDeck, card: Card)

## (Сигнал) Курсор кликнул левой кнопкой мыши по слоту для карточек.
signal card_slot_cursor_left_button_clicked(slot: PlayerCardSlot)
## (Сигнал) Курсор кликнул правой кнопкой мыши по слоту для краточек.
signal card_slot_cursor_right_button_clicked(slot: PlayerCardSlot)
## (Сигнал) Карточка помещена на слот для карточек.
signal card_slot_card_placed(slot: PlayerCardSlot, card: Card)