//
//  Taskfirst.swift
//  TbankIOS
/*
 Ваша задача — создать простое приложение на Swift, в котором вы будете использовать ARC (Automatic Reference Counting) для управления памятью. Спроектируйте классы с циклическими ссылками и правильно устраните их, чтобы показать, как управлять памятью.
 Задание:
 Создайте два класса: Person и Car:
 Класс Person должен иметь свойство name (строка) и также ссылку на Car, который он владеет.
 Класс Car также должен иметь свойство owner типа Person.
 Реализуйте инициализацию объектов:
 Убедитесь, что при создании объекта Person он получает ссылку на объект Car.
 При создании объекта Car он должен также ссылаться на объект Person.
 Показать проблемы с циклическими ссылками:
 Создайте экземпляры обоих классов и установите их ссылки друг на друга.
 Проверьте значение счетчика ссылок (используйте unowned или weak для устранения циклической ссылки).
 Печать значений Person и Car для проверки того, что они не освобождаются.
 Исправьте проблему циклической ссылки:
 Используйте weak или unowned для устранения циклической ссылки между Person и Car.
 Проверьте результаты:
 После устранения циклической ссылки проверьте, что оба объекта корректно освобождаются из памяти, когда они больше не используются.
 */
import Foundation

// Вспомогательная функция для получения счетчика ссылок
func getRetainCount(_ object: AnyObject) -> Int {
    return CFGetRetainCount(object) - 1 // -> вычитаю 1, т.к функция временно увеличивает счетчик
}
// Создаю класс Person
class Person {
    let name: String
    var car: Car? // -> ссылка на Car
    
    init(name: String, car: Car?) {
        self.name = name
        self.car = car
    }
    
    deinit {
        print("\(name) is deinitialized")
    }
}

class Car {
    let model: String
    var owner: Person? // -> сильная ссылка (для 1 примера)
    
    init(model: String, owner: Person?) {
        self.model = model
        self.owner = owner
    }
    
    deinit {
        print("\(model) is deinitialized")
    }
}

class WeakReferenceCar: Car {
    weak var weakOwner: Person? // -> Слабая ссылка (для 2 примера)
    
    init(model: String, weakOwner: Person?) {
        self.weakOwner = weakOwner
        super.init(model: model, owner: weakOwner)
    }
    
    deinit {
        print("\(model) is deinitialized (fixed version)")
    }
}
