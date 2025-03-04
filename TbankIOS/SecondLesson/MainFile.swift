//
//  main.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//

import Foundation
/*
 1
 Дана строка текста, вывести количество уникальных слов в этой строке. Слова разделены пробелами, регистр не учитывается.
 Подсказка: Обратите внимание на методы работы со строками (split, lowercased) и использование коллекций.
 */
class SecondLesson {
    static func start() {
        let string1 = "apple Orange pineapple PEAR"
        let string2 = "apple aPPle appLe Apple"
        print("Задача 1")
        print("--------------------------")
        print(getUnicalWord(in: string2))
        print(getUnicalWord(in: string1))
        print("--------------------------")
        // 2
        // Дана строка, состоящая только из круглых скобок. Проверить является ли последовательность скобок корректной и вывести результат в консоль.
        //
        
        print("Задача 2")
        print("--------------------------")
        let string3 = "(())"
        print(checkBrackets(in: string3).rawValue)
        
        let string4 = "))(("
        print(checkBrackets(in: string4).rawValue)
        
        let string5 = "()()()"
        print(checkBrackets(in: string5).rawValue)
        
        print("--------------------------")
        //    3
        // Дан массив строк. Нужно сгруппировать строки по количеству символов в ней, вывести результат.
        // Подсказка: Используйте правильную коллекцию.
        // */
        
        let array1 = ["a", "bb", "b", "cccc"]
        let array2 = ["a", "b", "c"]
        
        print("Задача 3")
        print("--------------------------")
        print(getGroupedStrings(with: array1))
        print(getGroupedStrings(with: array2))
        print("--------------------------")
        
        //    4
        // Есть словарь, в котором ключ - это имя студента, а значение - его оценка на экзамене (может быть nil, если не сдал). Нужно найти и вывести среднюю оценку только для студентов, у которых есть оценка. Если не сдали все, так и вывести.
        
        let dict1 = ["A": 4, "B": 4, "C": 4]
        let dict2: [String: Int?] = ["A": nil, "B": nil, "C": nil]
        
        print("Задача 4")
        print("--------------------------")
        countStudent(dict1)
        countStudent(dict2)
        print("--------------------------")
        /*
         5
         Создать перечисление математических операций над одним или двумя числами (сложение, деление, умножение, вычитание, квадрат числа, корень и другие, какие вы хотите). Минимум 5 различных операций.
         И дан массив, который состоит из математической операции и числами, над которым операция выполняется. Вывести результат всех операций.
         */
        
        let array3: [MathematicalOperation] = [.sum(1, 2), .square(2)]
        print("Задача 5")
        print("--------------------------")
        printOperationResult(with: array3)
        print("--------------------------")
    }
}
