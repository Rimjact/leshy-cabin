class_name CardData
extends Resource
## Постоянные данные карточки: имя, портрет, статы, цена и способности


## Отображаемое имя
@export var display_name: String = ""
## Текстура портрета
@export var portrait: Texture2D
## Область портрета на текстуре
@export var portrait_region: Rect2 = Rect2(1, 1, 43, 31)
## Очки здоровья
@export var health: int = 1
## Урон
@export var damage: int = 0
## Валюта обмена
@export var currency: Global.BarterCurrency = Global.BarterCurrency.FREE
## Стоимость в единицах валюты
@export_range(0, 6, 1) var cost: int = 0
## Сцены способностей в порядке их следования на карточке
@export var abilities: Array[PackedScene] = []
