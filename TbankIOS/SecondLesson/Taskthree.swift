//
//  Taskthree.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//
func groupStringsByLength(_ array: [String]) -> [Int: [String]] {
    var groupedStrings: [Int: [String]] = [:]
    
    // Группируем строки по их длине
    for word in array {
        let length = word.count
        if groupedStrings[length] != nil {
            groupedStrings[length]?.append(word)
        } else {
            groupedStrings[length] = [word]
        }
    }
    
    return groupedStrings
}

// Функция для вывода результата в нужном формате
func printGroupedStrings(_ groupedStrings: [Int: [String]]) {
    for key in groupedStrings.keys.sorted() {
        if let values = groupedStrings[key] {
            print("\(key) - \(values)")
        }
    }
}

