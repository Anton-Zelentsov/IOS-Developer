//
//  Taskfive.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//

import Foundation
/*
 Создать перечисление математических операций над одним или двумя числами (сложение, деление, умножение, вычитание, квадрат числа, корень и другие, какие вы хотите). Минимум 5 различных операций.
 И дан массив, который состоит из математической операции и числами, над которым операция выполняется. Вывести результат всех операций.
 Подсказка: Используйте enum с ассоциативными значениями.
 */


// Через enum MathematicalOperationType. Местами получилось слишком замудренно.
enum MathematicalOperation {
    private enum MathematicalOperationType: String {
        case sum = "Cумма"
        case division = "Деление"
        case multiplication = "Умножение"
        case minus = "Минус"
        case square = "Квадрат"
        
        init(mathemicalOperation: MathematicalOperation) {
            switch mathemicalOperation {
            case .sum(_, _):
                self = .sum
            case .division(_, _):
                self = .division
            case .multiplication(_, _):
                self = .multiplication
            case .minus(_, _):
                self = .minus
            case .square(_):
                self = .square
            }
        }
    }
    
    case sum(Int, Int) // +
    case division(Int, Int) // /
    case multiplication(Int, Int) // *
    case minus(Int, Int) // -
    case square(Int) // ^
    
    private var resultOperation: Int {
        var result = 0
        switch self {
        case .sum(let int, let int2):
            result = int + int2
        case .division(let int, let int2):
            result = int / int2
        case .multiplication(let int, let int2):
            result = int * int2
        case .minus(let int, let int2):
            result = int - int2
        case .square(let int):
            result = int * int
        }
        return result
    }
        
    var result: String {
        let operationTitle = MathematicalOperationType(mathemicalOperation: self).rawValue
        var result = "\(operationTitle) - \(self.resultOperation)"
        return result
    }
}

func printOperationResult(with array: [MathematicalOperation]) {
    for operation in array {
        print(operation.result)
    }
}
