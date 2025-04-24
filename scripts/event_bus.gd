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