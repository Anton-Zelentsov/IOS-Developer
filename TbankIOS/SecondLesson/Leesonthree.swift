//
//  Leesonthree.swift
//  TbankIOS
//
//  Created by macbook on 05.03.2025.
//

import Foundation

// Перечисление для жанров книг
enum Genre: String, CaseIterable {
    case fiction = "Фантастика"
    case novel = "Роман"
    case poems = "Поэзия"
    case detective = "Детектив"
    case science = "Научная литература"
}

// Структура для книги
struct Book {
    let title: String
    let author: String
    let price: Double
    let genre: Genre
}

// Класс библиотеки
class Library {
    private var books: [Book] = []
    
    // Добавление книги
    func addBook(_ book: Book) {
        books.append(book)
    }
    
    // Фильтрация по жанру
    func filterBooks(by genre: Genre) -> [Book] {
        return books.filter { $0.genre == genre }
    }
    
    // Фильтрация по названию
    func filterBooks(byName name: String) -> [Book] {
        return books.filter { $0.title.contains(name) }
    }
    
    // Получение всех книг
    func getAllBooks() -> [Book] {
        return books
    }
}

// Класс пользователя
class User {
    let name: String
    let discount: Double
    private var cart: [Book] = []
    
    init(name: String, discount: Double) {
        self.name = name
        self.discount = discount
    }
    
    // Добавление книг в корзину
    func addToCart(_ books: [Book]) {
        cart.append(contentsOf: books)
    }
    
    // Подсчет общей стоимости с учетом скидки
    func totalPrice() -> Double {
        let total = cart.reduce(0) { $0 + $1.price }
        return total * (1 - discount / 100)
    }
    
    // Сортировка корзины
    func sortedListOfBooks(by criteria: SortCriteria) -> [Book] {
        switch criteria {
        case .title:
            return cart.sorted { $0.title < $1.title }
        case .price:
            return cart.sorted { $0.price < $1.price }
        }
    }
    
    // Перечисление для критериев сортировки
    enum SortCriteria {
        case title
        case price
    }
}
