//
//  MainFile.swift
//  TbankProject
/*
 Создайте базовый класс GameCharacter:
    Свойства: name (String), health (Int), level (Int).
    Методы: takeDamage(amount: Int), heal(amount: Int), levelUp().

 Создайте ДВА подкласса от GameCharacter (на выбор, например, Warrior, Mage, Archer или свои):
 Для каждого подкласса:
 1-2 уникальных свойства (например, strength, magicPower, agility).
 1 специфичный метод атаки (например, attack(target:), castSpell(spellName: target:), shootArrow(target:)).
 Переопределите метод атаки (опционально) для уникальности.

  Создайте 1 или 2 протокола способностей (на выбор, например, Flyable, Healable или свои):
  Протокол должен требовать:
 1 свойство (например, flightSpeed),
 1 метод (например, fly()).
 Сделайте так, чтобы 1 или оба ваших подкласса персонажей соответствовали этим протоколам.

 Используйте расширения для класса GameCharacter:
 Добавьте вычисляемое свойство isAlive (Bool, health > 0).
 Добавьте метод printCharacterInfo() для вывода информации о персонаже в консоль.

 Продемонстрируйте работу системы:
 Создайте экземпляры персонажей разных типов.
 Продемонстрируйте взаимодействие: атаки, лечение (если есть), повышение уровня.
 Используйте printCharacterInfo() для вывода информации о персонажах.

 Необязательные задания "для героев":
 Реализуйте протокол Item и 2 типа игровых предметов (инвентарь - упрощенно).
 Кратко проанализируйте свой код на соответствие принципам SOLID (SRP и OCP).

 Критерии оценки:
 1. Корректность наследования и реализации протоколов (2 балла)
 +2: Используется наследование, классы корректно наследуют GameCharacter. Протоколы реализованы правильно.
 -1: Если протокол не реализован или реализован некорректно.
 -1: Если наследование реализовано неправильно или нарушена логика ООП.
 2. Работоспособность системы и логика взаимодействия (1 балла)
 +1: Код компилируется, персонажи могут атаковать, лечиться, взаимодействовать.
 -1: Логика работы метода атаки или других механик нарушена.
 -1: Отсутствует демонстрация работы системы (не созданы экземпляры, нет взаимодействий).
 3. Использование расширений (1 балл)
 +1: Используется extension для isAlive и printCharacterInfo().
 -0.5: Если одно из расширений отсутствует или реализовано некорректно.
 4. Качество кода (2 балла)
 +2: Код чистый, структурированный, удобочитаемый, использованы комментарии.
 -1: Присутствует дублирование кода, код запутанный.
 -1: Использование "магических чисел" вместо констант.
 5. Соответствие принципам SOLID (SRP, OCP) (2 балла)
 +2: Принципы SRP и OCP соблюдены (разные классы отвечают за одну задачу, код расширяем без изменений базового класса).
 -1: Если класс GameCharacter перегружен ответственностями (например, содержит логику инвентаря).
 -1: Если код сложно расширять (например, добавление новых персонажей требует изменения базового класса).
 6. Реализация необязательной части (1 балл)
 +1: Добавлены предметы (реализован протокол Item), персонажи могут использовать инвентарь.
 -0.5: Протокол Item реализован, но логика предметов не используется.
 7. Тестирование (1 балл)
 +1: Код протестирован (есть примеры создания персонажей и их взаимодействий).
 -0.5: Нет демонстрации тестов в коде.
 */

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
