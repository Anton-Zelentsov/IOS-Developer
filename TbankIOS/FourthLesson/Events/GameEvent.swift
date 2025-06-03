//
//  GameEvent.swift
//  TbankProject

enum CharacterEvent {
    case create(GameCharacter)
    case levelUp(GameCharacter)
    case dead(GameCharacter)
    case heal(GameCharacter, Double)
    case healIsUnsuccessful(GameCharacter)
}

enum FightEvent {
    case takeDamage(GameCharacter, GameCharacter, Double)
    case notHitted(GameCharacter, GameCharacter)
}

enum InventoryEvent {
    case createBackpack(Weaponable)
    case itemBackpackChanged(Weaponable)
    case currentItem(Weaponable)
    case weaponReloaded(Weaponable)
    case weaponReload(Weaponable)
    case shot(Weaponable)
    case reloadBeforeShot(Weaponable)
}

enum FlyingEvent {
    case fly(Flyable & GameCharacter)
}

enum GameEvent {
    case character(CharacterEvent)
    case combat(FightEvent)
    case inventory(InventoryEvent)
    case flying(FlyingEvent)
    case none

    var description: String {
        switch self {
        case .none:
            return "Событие отсутствует."
            
        case .character(let event):
            switch event {
            case .create(let hero):
                return "Герой \(hero.getName()) добавлен на поле боя"
            case .levelUp(let hero):
                return "Герой \(hero.getName()) увеличил уровень. Текущий уровень: \(hero.getLevel())."
            case .dead(let hero):
                return "Герой \(hero.getName()) мертв."
            case .heal(let hero, let amount):
                return "Герой \(hero.getName()) увеличил здоровье на \(amount). Текущий уровень здоровья: \(hero.getHealth())."
            case .healIsUnsuccessful(let hero):
                return "Герой \(hero.getName()) уже мертв. Восстановить здоровье невозможно."
            }

        case .combat(let event):
            switch event {
            case .takeDamage(let attacker, let target, let damage):
                return "Герой \(target.getName()) получил \(damage) урона от героя \(attacker.getName()). Текущий уровень здоровья: \(target.getHealth())."
            case .notHitted(let attacker, let target):
                return "Герой \(attacker.getName()) не попал в героя \(target.getName())."
            }

        case .inventory(let event):
            switch event {
            case .createBackpack(let backpack):
                return "Рюкзак с предметом \(backpack.title) создан."
            case .itemBackpackChanged(let item):
                return "Предмет в рюкзаке сменен на \(item.title) с уроном \(item.damage)."
            case .currentItem(let item):
                return "Текущий предмет в рюкзаке: \(item.title) с уроном \(item.damage)."
            case .weaponReloaded(let weapon):
                return "Оружие \(weapon.title) заряжено полностью."
            case .weaponReload(let weapon):
                return "Оружие \(weapon.title) перезаряжено."
            case .shot(let weapon):
                return "Выстрел из \(weapon.title)..."
            case .reloadBeforeShot(let weapon):
                return "Перезарядка оружия \(weapon.title) перед выстрелом."
            }

        case .flying(let event):
            switch event {
            case .fly(let character):
                return "Герой \(character.getName()) улетел."
            }
        }
    }
}

final class GameEventManager {
    static let shared = GameEventManager()

    private init() {}

    var currentEvent: GameEvent = .none {
        didSet {
            print(currentEvent.description)
        }
    }
}
