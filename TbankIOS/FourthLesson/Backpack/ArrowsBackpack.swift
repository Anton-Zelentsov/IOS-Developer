//
//  ArrowsBackpack.swift
//  TbankProject

protocol ArrowsBackpack: Backpackable {
    var item: BowWeaponable { get set }
    func printInfo()
    mutating func changeItem(_ item: BowWeaponable)
    init(item: BowWeaponable)
}

struct BackpackWithArrows: ArrowsBackpack {
    var item: BowWeaponable
    
    init(item: BowWeaponable) {
        self.item = item
        GameEventManager.shared.currentEvent = .inventory(.createBackpack(item))
    }
        
    mutating func changeItem(_ item: BowWeaponable) {
        self.item = item
        GameEventManager.shared.currentEvent = .inventory(.itemBackpackChanged(item))
    }
    
    func printInfo() {
        GameEventManager.shared.currentEvent = .inventory(.currentItem(item))
    }
}
