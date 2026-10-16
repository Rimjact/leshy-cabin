class_name OpponentSituation
extends RefCounted
## Снимок хода, по которому противник выбирает карту и действие


## Карты в руке противника
var hand: Array[CardBase] = []
## Текущее преимущество на шкале
var advantage: int = 0
## Кости противника
var bones: int = 0
## Сколько животных осталось в колоде противника
var animals_left: int = 0
## Обе колоды игрока пусты
var player_decks_empty: bool = false
