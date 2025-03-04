//
//  Tasktwo.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//

/*
    2
    Дана строка, состоящая только из круглых скобок. Проверить является ли последовательность скобок корректной и вывести результат в консоль.
 */

import Foundation

private enum BracketType: Character {
    case open = "("
    case close = ")"
}

enum BracketSequenceType: String {
    case correct = "Корректная"
    case incorrect = "Некорректная"
}

func checkBrackets(in string: String) -> BracketSequenceType {
    guard string.count >= 1 else { return .incorrect }
    
    var correctorValue = 0
    for item in string {
        guard let bracket = BracketType(rawValue: item) else { continue }
        switch bracket {
        case .open:
            correctorValue += 1
        case .close:
            correctorValue -= 1
        }
        
        if correctorValue < 0 {
            return .incorrect
        }
    }
    return correctorValue == 0 ? .correct : .incorrect
}
