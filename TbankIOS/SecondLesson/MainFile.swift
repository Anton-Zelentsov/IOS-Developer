//
//  main.swift
//  Tbank-IOS
//
//  Created by macbook on 01.03.2025.
//

import Foundation

class SecondLesson{
    static func start(){
        // Тестирование
        let library = Library()
        library.addBook(
            Book(
                title: "Гарри Поттер и философский камень",
                author: "Дж.К. Роулинг",
                price: 1000,
                genre: .fiction
            )
        )
        library.addBook(
            Book(
                title: "Война и мир",
                author: "Лев Толстой",
                price: 850,
                genre: .novel
            )
        )
        library.addBook(
            Book(
                title: "Стихотворение",
                author: "Владимир Маяковский",
                price: 540,
                genre: .poems
            )
        )

        let user = User(name: "Алиса", discount: 1.5)

        // Фильтрация книг по жанру и добавление в корзину
        let novelBooks = library.filterBooks(by: .novel)
        user.addToCart(novelBooks)

        // Фильтрация книг по названию и добавление в корзину
        let booksWithName = library.filterBooks(byName: "Гарри")
        user.addToCart(booksWithName)

        // Вывод отсортированной корзины и общей стоимости
        print("Итоговая корзина (по названию):")
        for book in user.sortedListOfBooks(by: .title) {
            print("\(book.title) - \(book.author) - \(book.price) руб.")
        }

        print("\nИтоговая корзина (по цене):")
        for book in user.sortedListOfBooks(by: .price) {
            print("\(book.title) - \(book.author) - \(book.price) руб.")
        }

        print("\nЦена корзины с учетом скидки: \(user.totalPrice()) руб.")
    }
}
