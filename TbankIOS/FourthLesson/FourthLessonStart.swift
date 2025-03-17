//
//  MainFile.swift
//  TbankProject


class FourthHomework{
    static func start() {
        let healingStandardStrategy = StandardHeal()
        let healingIncreasedStrategy = IncreasedHeal(increasedHealСhance: 75, healCoefficient: 2)
        
        let fastFlyStrategy = FastFly()
        let slowFlyStrategy = SlowFly()
        
        let archerBackpack = BackpackWithArrows(item: WoodenBow(maximalCountBullets: 1,
                                                                distance: 8.5,
                                                                damage: 38.5))
        
        let archerBackpack2 = BackpackWithArrows(item: GoldBow(maximalCountBullets: 1,
                                                               distance: 12.5,
                                                               damage: 45.8))
        
        let mageBackpak = MysticBeltBag(item: Fireball(damage: 46.5,
                                                       maximalCountBullets: 5,
                                                       distance: 8.8))
        
        let mageBackpack2 = MysticBeltBag(item: GoldenBall(damage: 55,
                                                           maximalCountBullets: 1,
                                                           distance: 9))
        
        
        let archer1 = Archer(name: "Archer1",
                             accuracy: 75,
                             healValue: 35,
                             healingStrategy: healingIncreasedStrategy,
                             backpack: archerBackpack)
        
        let archer2 = Archer(name: "Archer2",
                             accuracy: 68,
                             healValue: 30,
                             healingStrategy: healingIncreasedStrategy,
                             backpack: archerBackpack2)
        
        // ===
        
        let mage1 = Mage(name: "Mage1",
                         flighthDistance: 12,
                         accuracy: 65,
                         healValue: 32,
                         healingStrategy: healingStandardStrategy,
                         flyingStrategy: slowFlyStrategy,
                         backpack: mageBackpak)
        
        let mage2 = Mage(name: "Mage2",
                         flighthDistance: 7,
                         accuracy: 75,
                         healValue: 28,
                         healingStrategy: healingIncreasedStrategy,
                         flyingStrategy: fastFlyStrategy,
                         backpack: mageBackpack2)
        
        archer1.printCharacterInfo()
        archer2.printCharacterInfo()
        mage1.printCharacterInfo()
        mage2.printCharacterInfo()
        
        archer1.shootArrow(target: mage2)
        archer1.levelUp()
        archer1.levelUp()
        archer1.levelUp()
        
        archer1.shootArrow(target: archer2)
        archer1.printCharacterInfo()
        archer2.printCharacterInfo()
        
        archer2.heal(amount: archer2.healValue)
        archer2.shootArrow(target: mage2)
        archer2.shootArrow(target: mage2)
        mage2.heal(amount: mage2.healValue)
        mage2.heal(amount: mage2.healValue)
        archer2.shootArrow(target: mage2)
        archer2.shootArrow(target: mage2)
        archer2.shootArrow(target: mage2)
        archer2.levelUp()
        archer2.levelUp()
        archer2.printCharacterInfo()
        
        mage1.fly(direction: .toLeft)
        mage1.castSpell(spellName: .fireSpell, target: archer2)
        mage1.printCharacterInfo()
    }
    
}
