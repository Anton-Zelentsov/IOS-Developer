//
//  Backpack.swift
//  TbankProject

protocol MysticableBackpack: Backpackable {
    var item: MysticWeaponable { get set }
    mutating func changeItem(_ item: MysticWeaponable)
    func printInfo()
    init(item: MysticWeaponable)
}

struct MysticBeltBag: MysticableBackpack {
    var item: MysticWeaponable
    
    init(item: MysticWeaponable) {
        self.item = item
    }
        
    mutating func changeItem(_ item: MysticWeaponable) {
        self.item = item
    }
    
    func printInfo() {
        GameEventManager.shared.currentEvent = .inventory(.currentItem(item))
    }
}
