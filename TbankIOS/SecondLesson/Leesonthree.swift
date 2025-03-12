//  Leesonthree.swift
//  TbankIOS
//
//  Created by macbook on 05.03.2025.
/*
 1. Создайте структуру книги, которая позволит хранить в себе: Название, Автора, Цену, Жанр (сделайте количество жанров ограниченным используя перечисление).
 2. Создайте класс библиотеки. В нем мы будем хранить книги.
 - Добавьте методы:
 - Добавление книги.
 - Фильтрация по жанру.
 - Фильтрация по имени.
 3. Создайте класс пользователя. У него будет имя, скидка в магазине и корзина с книгами.
 - Добавьте методы:
 - Добавление книг в корзину.
 - Подсчет общей стоимости книг в корзине с учетом скидки пользователя.
 - Вывод корзины в отсортированном порядке (сделайте различные варианты сортировки по алфавиту/по цене, используя один метод).
 */

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
    func addToCart(_ book:Book){
    cart.append(book)
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
