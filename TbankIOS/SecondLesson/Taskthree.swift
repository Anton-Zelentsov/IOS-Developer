//
//  Taskthree.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//

import Foundation
/*
 3
 Дан массив строк. Нужно сгруппировать строки по количеству символов в ней, вывести результат.
 Подсказка: Используйте правильную коллекцию.
 */

func getGroupedStrings(with array: [String]) -> [Int: [String]] {
    var groupedStrings: [Int: [String]] = [:]
    
    for word in array {
        let length = word.count
        if let _ = groupedStrings[length] {
            // не придумал, как обойти проверку массива. Пробовал через guard, но получается еще хуже. Значение массива (_) нам не нужно, так как надо записывать не в копию, а в оригинальный массив
            groupedStrings[length]?.append(word)
        } else {
            groupedStrings[length] = [word]
        }
    }
    return groupedStrings
}
