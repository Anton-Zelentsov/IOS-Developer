import Foundation
// Задание 5
class FiveLesson {
    static func demonstrateReferenceCycles() {
        print("Пример с циклом сильных ссылок")
        
        var person: Person? = Person(name: "Anton", car: nil)
        var car: Car? = Car(model: "Bugatti Chiron", owner: nil)
        
        print("После создания объектов:")
        print("Счетчик ссылок Person: \(getRetainCount(person!))")
        print("Счетчик ссылок Car: \(getRetainCount(car!))")
        
        // Создаю цикл сильных ссылок
        person?.car = car
        car?.owner = person
        
        print("После создания цикла ссылок:")
        print("Счетчик ссылок Person: \(getRetainCount(person!))")
        print("Счетчик ссылок Car: \(getRetainCount(car!))")
        
        print("Перед установкой в nil:")
        print("Person's car: \(person?.car?.model ?? "No car")")
        print("Car's owner: \(car?.owner?.name ?? "No owner")")
        
        person = nil
        car = nil
        
        print("После установки в nil (объекты не освобождаются из-за цикла)")
    }
    
    static func demonstrateWeakReferenceSolution() {
        print("Пример с weak ссылкой")
        
        var person: Person? = Person(name: "Anton", car: nil)
        var car: WeakReferenceCar? = WeakReferenceCar(model: "Porsche 911", weakOwner: nil)
        
        print("После создания объектов:")
        print("Счетчик ссылок Person: \(getRetainCount(person!))")
        print("Счетчик ссылок Car: \(getRetainCount(car!))")
        
        // Устанавливаю ссылки
        person?.car = car
        car?.weakOwner = person
        
        print("После установки ссылок:")
        print("Счетчик ссылок Person: \(getRetainCount(person!))")
        print("Счетчик ссылок Car: \(getRetainCount(car!))")
        
        print("Перед установкой в nil:")
        print("Person's car: \(person?.car?.model ?? "No car")")
        print("Car's owner: \(car?.weakOwner?.name ?? "No owner")")
        
        person = nil
        car = nil
        
        print("После установки в nil (объекты освобождаются корректно)")
    }
    
    static func demonstrateAnimals() {
        print("Задание 6")
        let animals: [Animal] = [Dog(), Cat(), Dog()]
        for animal in animals {
            animal.speak()
        }
    }
    static func printMessage() {
        demonstrateReferenceCycles()
        demonstrateWeakReferenceSolution()
        demonstrateAnimals()
    }
}
