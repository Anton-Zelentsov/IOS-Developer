//
//  Protocols.swift
//  TbankProject

enum FlyDirection: String {
    case forward = "Вперед"
    case back = "Назад"
    case toLeft = "Налево"
    case toRight = "Направо"
}

protocol Flyable {
    var flighthDistance: Double { get }
    func fly(direction: FlyDirection)
}

protocol Healable {
    var healValue: Double { get }
    func heal(amount: Double, for: GameCharacter)
}
