//
//  Taskone.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//

/*
        1
 
 Дана строка текста, вывести количество уникальных слов в этой строке. Слова разделены пробелами, регистр не учитывается.
 Подсказка: Обратите внимание на методы работы со строками (split, lowercased) и использование коллекций.
 */
import Foundation

private enum SeparatorType: String {
    case emptySymbol = " "
}

public func getUnicalWord(in string: String) -> Int {
    let string = string.lowercased().split(separator: SeparatorType.emptySymbol.rawValue)
    let unicalStrings = Set(string)
    return unicalStrings.count
}
