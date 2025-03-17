//
//  File.swift
//  TbankProject


protocol MysticWeaponable: Weaponable {
    mutating func reload()
    mutating func shot()
}

enum MysticWeaponType: String {
    case fireball = "Огненный шар"
    case goldenball = "Золотой шар"
}
// Здесь ситуация такая же, как и в BowWeapons.
private protocol MysticWeapon {
    var damage: Double { get }
    var distance: Double { get }
    var maximalCountBullets: Int { get }
    var countBullets: Int { get }
}

struct Fireball: MysticWeapon, MysticWeaponable {
    let damage: Double
    var title: MysticWeaponType.RawValue {
        MysticWeaponType.fireball.rawValue
    }
    
    fileprivate let maximalCountBullets: Int
    fileprivate let distance: Double
    
    fileprivate var countBullets: Int {
        didSet {
            if !isReloaded { reload() }
        }
    }
    
    private var isReloaded: Bool {
        (countBullets > 0) && (countBullets <= maximalCountBullets)
    }
    
    init(damage: Double, maximalCountBullets: Int, distance: Double) {
        self.damage = damage
        self.maximalCountBullets = maximalCountBullets
        self.distance = distance
        self.countBullets = maximalCountBullets
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

struct GoldenBall: MysticWeapon, MysticWeaponable {
    var damage: Double
    var title: MysticWeaponType.RawValue {
        MysticWeaponType.goldenball.rawValue
    }
    
    fileprivate let maximalCountBullets: Int
    fileprivate var distance: Double
    
    fileprivate var countBullets: Int {
        didSet {
            if !isReloaded { reload() }
        }
    }
    private var isReloaded: Bool {
        (countBullets > 0) && (countBullets <= maximalCountBullets)
    }
    
    init(damage: Double, maximalCountBullets: Int, distance: Double) {
        self.damage = damage
        self.maximalCountBullets = maximalCountBullets
        self.distance = distance
        self.countBullets = maximalCountBullets
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
