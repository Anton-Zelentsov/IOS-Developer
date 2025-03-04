//
//  Taskfour.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//

import Foundation
// Задача №4
// Условие:
/* Есть словарь, в котором ключ - это имя студента, а значение - его оценка на экзамене (может быть nil, если не сдал). Нужно найти и вывести среднюю оценку только для студентов, у которых есть оценка. Если не сдали все, так и вывести.
 let dict1 = ["A": 4, "B": 4, "C": 4]
 Output: 4

 let dict2 = ["A": nil, "B": nil, "C": nil]
 Output: Никто не сдал */
// Решение:
func countStudent(_ grades: [String: Int?]) {
    // Фильтруем студентов, у которых есть оценка
    let validGrades = grades.compactMapValues { $0 } // {$0} - замыкание (closure), то есть сокращенный синтаксис, {$0}- просто возращает значение, которое передали. {$0}- принимает один аргумент и возвращает
    
    // Проверяем, есть ли студенты с оценками
    if validGrades.isEmpty {
        print("Никто не сдал")
    } else {
        // Вычисляем среднюю оценку
        let average = validGrades.values.reduce(0, +) / validGrades.count // reduce(0,+)- суммирует все значения в массиве, validGrades - среднее значение вычисляет
        print(average)
    }
}

