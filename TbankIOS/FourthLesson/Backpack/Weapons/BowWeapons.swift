//
//  Items.swift
//  TbankProject

protocol BowWeaponable: Weaponable {
    mutating func reload()
    mutating func shot()
}

enum BowType: String {
    case woodenBow = "Деревянный лук со стрелами"
    case goldBow = "Золотой лук со стрелами"
    case crossBow = "Арбалет"
}

// Нужно ли скидывать private протокол в самый низ? Так как вверху все internal. Просто, как будто, в данном случае лучше оставить протокол вверху.
// И не совсем расшиемый код получился, так как, с одной стороны, данные этого протокола инкапсулированы, а с другой стороны данный протокол в другом файле не получится использовать. И, условно, если бы у нас было 100 оружий, то придется писать их в один этот файл))
// Единственным адекватным решением в данном случае вижу создание отделного модуля с оружиями. Можно ли в следующих домашних заданиях попробовать разделять все на отдельные логические модули? В данном случае данной проблемы получилось бы избежать)

private protocol BowProtocol {
    var countBullets: Int { get set }
    var distance: Double { get }
    var maximalCountBullets: Int { get }
    mutating func reload()
    mutating func shot()
}

struct WoodenBow: BowProtocol, BowWeaponable {
    let damage: Double
    
    var title: BowType.RawValue {
        BowType.woodenBow.rawValue
    }
    
    fileprivate var countBullets: Int {
        didSet {
            if !isReloaded { reload() }
        }
    }
    
    fileprivate let maximalCountBullets: Int
    fileprivate let distance: Double
    
    private var isReloaded: Bool {
        (countBullets > 0) && (countBullets <= maximalCountBullets)
    }
    
    init(maximalCountBullets: Int, distance: Double, damage: Double) {
        self.maximalCountBullets = maximalCountBullets
        self.countBullets = maximalCountBullets
        self.distance = distance
        self.damage = damage
    }
    
    mutating func reload() {
        if maximalCountBullets == countBullets {
            GameEventManager.shared.currentEvent = .inventory(.weaponReloaded(self))
        } else if countBullets < maximalCountBullets {
            countBullets = maximalCountBullets
            GameEventManager.shared.currentEvent = .inventory(.weaponReload(self))
        }
    }
    
    mutating func shot() {
        guard isReloaded else {
            GameEventManager.shared.currentEvent = .inventory(.reloadBeforeShot(self))
            reload()
            return
        }
        
        GameEventManager.shared.currentEvent = .inventory(.shot(self))
        countBullets -= 1
    }
}

struct GoldBow: BowProtocol, BowWeaponable {
    let damage: Double
    
    var title: BowType.RawValue {
        BowType.goldBow.rawValue
    }
    
    fileprivate var countBullets: Int {
        didSet {
            if !isReloaded { reload() }
        }
    }
    
    fileprivate let maximalCountBullets: Int
    fileprivate let distance: Double
    
    private var isReloaded: Bool {
        (countBullets > 0) && (countBullets <= maximalCountBullets)
    }
    
    init(maximalCountBullets: Int, distance: Double, damage: Double) {
        self.maximalCountBullets = maximalCountBullets
        self.countBullets = maximalCountBullets
        self.distance = distance
        self.damage = damage
    }
    
    mutating func reload() {
        if maximalCountBullets == countBullets {
            GameEventManager.shared.currentEvent = .inventory(.weaponReloaded(self))
        } else if countBullets < maximalCountBullets {
            countBullets = maximalCountBullets
            GameEventManager.shared.currentEvent = .inventory(.weaponReload(self))
        }
    }
    
    mutating func shot() {
        guard isReloaded else {
            GameEventManager.shared.currentEvent = .inventory(.reloadBeforeShot(self))
            reload()
            return
        }
        
        GameEventManager.shared.currentEvent = .inventory(.shot(self))
        countBullets -= 1
    }
}

struct CrossBow: BowProtocol, BowWeaponable {
    let damage: Double
    var title: BowType.RawValue {
        BowType.crossBow.rawValue
    }
    
    fileprivate var countBullets: Int {
        didSet {
            if !isReloaded { reload() }
        }
    }
    
    fileprivate let maximalCountBullets: Int
    fileprivate let distance: Double
    
    private var isReloaded: Bool {
        (countBullets > 0) && (countBullets <= maximalCountBullets)
    }
    
    init(maximalCountBullets: Int, distance: Double, damage: Double) {
        self.maximalCountBullets = maximalCountBullets
        self.countBullets = maximalCountBullets
        self.distance = distance
        self.damage = damage
    }
    
    mutating func reload() {
        if maximalCountBullets == countBullets {
            GameEventManager.shared.currentEvent = .inventory(.weaponReloaded(self))
        } else if countBullets < maximalCountBullets {
            countBullets = maximalCountBullets
            GameEventManager.shared.currentEvent = .inventory(.weaponReload(self))
        }
    }
    
    mutating func shot() {
        guard isReloaded else {
            GameEventManager.shared.currentEvent = .inventory(.reloadBeforeShot(self))
            reload()
            return
        }

        GameEventManager.shared.currentEvent = .inventory(.shot(self))
        countBullets -= 1
    }
}
