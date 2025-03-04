//
//  Taskfour.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//

import Foundation

func countStudent(_ grades: [String: Int?]) {
    // Фильтруем студентов, у которых есть оценка
    let validGrades = grades.compactMapValues { $0 }
    
    // Проверяем, есть ли студенты с оценками
    if validGrades.isEmpty {
        print("Никто не сдал")
    } else {
        // Вычисляем среднюю оценку с плавающей точкой
        let sum = validGrades.values.reduce(0, +)
        let average = Double(sum) / Double(validGrades.count) // Используем Double для точного деления
        print(average)
    }
}

