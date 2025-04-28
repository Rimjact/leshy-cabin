extends Node
## Глобальный скрипт.


## Состояние карточки.
enum CardState {
	IN_DECK,
	IN_HAND,
	IN_SLOT,
}
## Типы колод карточек.
enum DeckType {
	ANIMALS = 2,
	SQUIRRELS = 4,
}

## (Константа) Максимальная ширина колоды карточек в руке.
const MAX_HAND_DECK_WIDTH: float = 224
## (Константа) Ширина игровой карточки + правый отступ.
const CARD_WIDTH: float = 49 + 2
## (Константа) Скорость анимации атаки карточки.
const CARD_ATTACK_ANIMATION_SPEED: float = 0.1
## (Константа) Стратовое количество карт в колоде животных.
const DECK_ANIMALS_SIZE: int = 8
## (Константа) Стартовое количество карт в колоде белок.
const DECK_SQUIRRELS_SIZE: int = 11