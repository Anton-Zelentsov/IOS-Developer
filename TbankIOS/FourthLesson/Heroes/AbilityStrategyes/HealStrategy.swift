//
//  ArcherHealStrategy.swift
//  TbankProject

protocol HealingStrategy {
    func heal(amount: Double, for hero: GameCharacter)
}

final class StandardHeal: HealingStrategy {
    func heal(amount: Double, for hero: GameCharacter) {
        hero.heal(amount: amount)
    }
}

final class IncreasedHeal: HealingStrategy {
    private let increasedHealСhance: Double
    private let healCoefficient: Double
    
    private var isIncreaseddHeal: Bool {
        return (Double.random(in: 1...100) <= increasedHealСhance)
    }
    
    init(increasedHealСhance: Double, healCoefficient: Double) {
        self.increasedHealСhance = increasedHealСhance
        self.healCoefficient = healCoefficient
    }
    
    func heal(amount: Double, for hero: GameCharacter) {
        let amount = (Double.random(in: 1...100) <= increasedHealСhance) ? (amount * healCoefficient) : amount
        hero.heal(amount: amount)
    }
}


