extends Node
## Скрипт для глобального доступа


## Типы состояния карточки
enum CardState {
	IN_DECK,
	IN_HAND,
	IN_HAND_HOVERED,
	IN_HAND_SELECTED,
	IN_SLOT,
	ON_MOVE,
}
## Типы колод карточек
enum DeckType {
	ANIMALS,
	SQUIRRELS,
}
## Типы состояния игры
enum GameState {
	GAME_INIT = 0,
	PLAYER_PICK_CARD = 1,
	PLAYER_TURN = 2,
	PLAYER_CARDS_ATTACK = 3,
	PLAYER_SHOW_HEARTS_BAR = 4,
	OPPONENT_PICK_CARD = 5,
	OPPONENT_TURN = 6,
	OPPONENT_CARDS_ATTACK = 7,
	OPPONENT_SHOW_HEARTS_BAR = 8,
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
