//
//  Taskfive.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//
import Foundation

// Перечисление для математических операций
public enum MathematicalOperation {
    case sum(Double, Double) // Сложение
    case division(Double, Double) // Деление
    case multiplication(Double, Double) // Умножение
    case minus(Double, Double) // Вычитание
    case square(Double) // Квадрат числа
    case squareRoot(Double) // Квадратный корень
    
    // Вычисление результата операции
    private var resultOperation: Double {
        switch self {
        case .sum(let a, let b):
            return a + b
        case .division(let a, let b):
            return a / b
        case .multiplication(let a, let b):
            return a * b
        case .minus(let a, let b):
            return a - b
        case .square(let a):
            return a * a
        case .squareRoot(let a):
            return sqrt(a)
        }
    }
    
    // Описание операции и результата
    public var result: String {
        let operationDescription: String
        switch self {
        case .sum(let a, let b):
            operationDescription = "Сумма \(a) и \(b)"
        case .division(let a, let b):
            operationDescription = "Деление \(a) на \(b)"
        case .multiplication(let a, let b):
            operationDescription = "Умножение \(a) на \(b)"
        case .minus(let a, let b):
            operationDescription = "Вычитание \(b) из \(a)"
        case .square(let a):
            operationDescription = "Квадрат числа \(a)"
        case .squareRoot(let a):
            operationDescription = "Квадратный корень из \(a)"
        }
        return "\(operationDescription) = \(self.resultOperation)"
    }
}

// Функция для вывода результатов операций
public func printOperationResult(with array: [MathematicalOperation]) {
    for operation in array {
        print(operation.result)
    }
}

