extends Node
## Скрипт для глобального доступа


## Типы состояний карточки
enum CardState {
	IN_DECK,
	IN_HAND,
	IN_HAND_HOVERED,
	IN_HAND_SELECTED,
	IN_SLOT,
}
## Типы колод карточек
enum DeckType {
	ANIMALS,
	SQUIRRELS,
}

## (Константа) Максимальная ширина колоды карточек в руке (пикселей)
const MAX_HAND_DECK_WIDTH_PIX: float = 224
## (Константа) Ширина карточки + правый отступ
const CARD_WIDTH_PIX: float = 49 + 2
## (Константа) Скорость анимации атаки у карточки
const CARD_ATTACK_ANIM_SPEED: float = 0.1
## (Константа) Количество карт в колоде животных
const DECK_ANIMALS_SIZE_COUNT: int = 8
## (Константа) Количество карт в колоде белок
const DECK_SQUIRRELS_SIZE_COUNT: int = 11
