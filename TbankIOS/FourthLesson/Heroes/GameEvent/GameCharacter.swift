
//  GameCharacter.swift
//  TbankProject
// SOLID:
// SRP - Соответсвует данному принципу, так как данный класс не выполняет никаких дополнительных действий, которые не принадлежат герою.
// OCP - Больше не соответсвует, чем соответсвует. С одной стороны, данный класс можно расширять без модификации классов-наследников, но, с другой стороны класс не является гибким и расширяемым, так как хранит логику основых функций внутри. Лучшим решением, я думаю, было бы создание дополнительных стратегий (как я сделал с Flyable, Healable). И реализацию основного функционала можно было бы изменять не трогая реализацию данного класса (Но не уверен, что в данном случае это является хорошим решением).
// LSP - Буду смотреть в классах-наследниках.
// ISP - Данный класс не реализует протоколы, неиспользуемых методов нет.
// DIP - Думаю, что данный класс соответсует данному принципу. Так как, например, мы не работает с конткретным типом рюкзака, а работаем с абстракцией. Если бы я создал стратегию для некоторой функциональности, но, было бы, конечно еще лучше. Я бы тоже не работал с конкретной реализацией)

// НО, считаю серьезным нарушением иметь возможность создания данного класса. Так как, класс GameCharacter является классом-абстракцией и не несет никакой конкретной реализации конткретного героя. Я не придумал никого грамотного и адекватного способа заприватить инициализатор и наследовать классы-герои от этого "абстрактного класса". Думаю, что частично задача с созданием КЛАССА является несовсем корректной и лучшим решением в данном случае использовать протокол???)

class GameCharacter {
    private static let minimalHealth = 0.0
    private static let maximalHealth = 100.0
    private static let minimalLevel = 0

    private let backpack: Backpackable
    private let accuracy: Double
    private let name: String
    private var level: Int
    
    private var health: Double {
        didSet {
            if isKilled && (health != GameCharacter.minimalHealth) {
                health = GameCharacter.minimalHealth
            } else if isAlive && (health > GameCharacter.maximalHealth) {
                health = GameCharacter.maximalHealth
            }
        }
    }
 
    init(name: String,
         accuracy: Double,
         backpack: Backpackable,
         health: Double = GameCharacter.maximalHealth,
         level: Int = GameCharacter.minimalLevel) {
        
        self.name = name
        self.accuracy = accuracy
        self.health = health
        self.level = level
        self.backpack = backpack
        
        GameEventManager.shared.currentEvent = .character(.create(self))
    }

    func heal(amount: Double) {
        guard isAlive else {
            GameEventManager.shared.currentEvent = .character(.healIsUnsuccessful(self))
            return
        }
        
        health += amount
        GameEventManager.shared.currentEvent = .character(.heal(self, amount))
    }

    func attack(target: GameCharacter, with item: Weaponable) {
        guard target.isAlive else {
            GameEventManager.shared.currentEvent = .character(.dead(target))
            return
        }
        
        guard self.isAlive else {
            GameEventManager.shared.currentEvent = .character(.dead(self))
            return
        }
        
        if isHitted {
            let damage = item.damage
            target.takeDamage(damage: damage)
            GameEventManager.shared.currentEvent = .combat(.takeDamage(self, target, damage))
        } else {
            GameEventManager.shared.currentEvent = .combat(.notHitted(self, target))
        }
    }
    
    func levelUp() {
        level += 1
        GameEventManager.shared.currentEvent = .character(.levelUp(self))
    }

    func printCharacterInfo() {
        print("---------------------------")
        print("Полная информация о герое:")
        print("Наименование героя - ", name)
        print("Уровень героя - ", level)
        print("Процент здоровья героя - ", health)
        print("---------------------------")
    }
    
    private func takeDamage(damage: Double) {
        health -= damage
    }
}

extension GameCharacter {
    func getHealth() -> Double {
        health
    }

    func getName() -> String {
        name
    }

    func getLevel() -> Int {
        level
    }
}

private extension GameCharacter {
    var isHitted: Bool {
        accuracy >= Double.random(in: 1...100)
    }

    var isAlive: Bool {
        health > GameCharacter.minimalHealth
    }

    var isKilled: Bool {
        !isAlive
    }
}
