//
//  FlyStrategy.swift
//  TbankProject

protocol FlyingStrategy {
    func fly(character: GameCharacter, direction: FlyDirection)
}

final class StandardFly: FlyingStrategy {
    func fly(character: GameCharacter, direction: FlyDirection) {
        print("\(character.getName()) летит \(direction.rawValue) на обычной скорости.")
    }
}

final class FastFly: FlyingStrategy {
    func fly(character: GameCharacter, direction: FlyDirection) {
        print("\(character.getName()) мчится \(direction.rawValue) с невероятной скоростью.")
    }
}

final class SlowFly: FlyingStrategy {
    func fly(character: GameCharacter, direction: FlyDirection) {
        print("\(character.getName()) медленно передвигается \(direction.rawValue)")
    }
}
