
// SOLID
// SRP - В целом, считаю что данный класс соответствует данному принципу. Данный класс не хранит никих лишних реализаций. А реализации прототоколов Flyable, Healable вынесены в отдельные стратегии.
// OCP - Данный класс соответствует данному принципу, так как различные поведения я могу менять, не изменяя логику класса
// LSP - Не изменяю логику суперкласса (но и не дополняю ее). Данный класс соответсвует данному принципу.
// ISP - Не применяю в данном классе
// DIP - Данный класс не зависит от конкретных реализаций, он зависит от абстракций (Не работаю с конкретным рюкзаком, работаю с абстракцией стратегий).

final class Mage: GameCharacter {
    enum SpellType: String {
        case healHeroSpell = "Ахалай-махалай"
        case selfHealSpell = "Пожить-пожить"
        case fireSpell = "Огонь!"
    }
    
    let healValue: Double
    let flighthDistance: Double
    
    private var backpack: MysticableBackpack
    private var flyingStrategy: FlyingStrategy
    private var healingStrategy: HealingStrategy
    
    init(name: String,
         flighthDistance: Double,
         accuracy: Double,
         healValue: Double,
         healingStrategy: HealingStrategy,
         flyingStrategy: FlyingStrategy,
         backpack: MysticableBackpack) {
        
        self.flighthDistance = flighthDistance
        self.healValue = healValue
        self.healingStrategy = healingStrategy
        self.flyingStrategy = flyingStrategy
        self.backpack = backpack
        super.init(name: name, accuracy: accuracy, backpack: backpack)
    }
    
    func castSpell(spellName: SpellType, target: GameCharacter) {
        switch spellName {
        case .healHeroSpell:
            healingStrategy.heal(amount: healValue, for: target)
        case .selfHealSpell:
            healingStrategy.heal(amount: healValue, for: target)
        case .fireSpell:
            self.backpack.item.shot()
            self.attack(target: target, with: backpack.item)
        }
    }
}

extension Mage: Flyable {
    func fly(direction: FlyDirection) {
        flyingStrategy.fly(character: self, direction: direction)
    }
    
    func changeFlyingStrategy(_ newStrategy: FlyingStrategy) {
        self.flyingStrategy = newStrategy
    }
}

extension Mage: Healable {
    func changeHealingStrategy(_ newStrategy: HealingStrategy) {
        self.healingStrategy = newStrategy
    }
    
    func heal(amount: Double, for hero: GameCharacter) {
        healingStrategy.heal(amount: amount, for: hero)
    }
}
