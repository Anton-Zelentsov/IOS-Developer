//  Archer.swift
//  TbankProject

// SOLID
// Думаю, что данный класс соответствует принципам:
// SRP - В целом, класс (Лучник) решает только свои потребности, такие как: атака противника, "индивидуальные" качества лучника,  восстановлене здоровья себе или любому наследнику класса GameCharacter.
// Open-close principle - Думаю, что данный класс соответсует OCP, так как "ненужную" логику я реализовал с помоью паттерна "стратегия" и в случае изменения реализации восстановления здоровья или атаки мне не нужно трогать основной класс Лучника.
// LSP - Нигде не дополняю реализацию класса-родителя
// ISP - Вроде бы в данном классе и классах стратегии он не используется
// DIP - Вытекает из OCP. Благодаря вынесению логики из класса, Лучник не зависит от конкретной реазиции восстановелния здоровья или атаки. Можно в случае чего просто менять разные реазиации стратегий.

final class Archer: GameCharacter {
    let healValue: Double
    private var healingStrategy: HealingStrategy
    private var backpack: ArrowsBackpack
    
    init(name: String,
         accuracy: Double,
         healValue: Double,
         healingStrategy: HealingStrategy,
         backpack: ArrowsBackpack) {
        
        self.healValue = healValue
        self.healingStrategy = healingStrategy
        self.backpack = backpack
        super.init(name: name, accuracy: accuracy, backpack: backpack)
    }

    func shootArrow(target: GameCharacter) {
        self.backpack.item.shot()
        self.attack(target: target, with: backpack.item)
    }
}

extension Archer: Healable {
    func changeHealingStrategy(_ newStrategy: HealingStrategy) {
        self.healingStrategy = newStrategy
    }
    
    func heal(amount: Double, for hero: GameCharacter) {
        healingStrategy.heal(amount: amount, for: hero)
    }
}
