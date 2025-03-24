import Foundation
class FiveLesson{
    static func printMessage(){
        // Задание 5
        print("Задание 5")
        var person: Person? = Person(name: "Anton", car: nil)
        var car: Car? = Car(model: "Bugatti Chiron", owner: nil)
        // Циклические ссылки
        person?.car = car
        car?.owner = person

        // Проверка этих ссылок (без weak)
        print("Before setting to nil:")
        print("Person's car: \(person?.car?.model ?? "No car")")
        print("Car's owner: \(car?.owner?.name ?? "No owner")")

        // Освобождаю объекты, т.е nil
        person = nil
        car = nil

        // Делаю провекру на освобождение памяти
        print("After setting to nil:")
        print("Person's car: \(person?.car?.model ?? "No car")")
        print("Car's owner: \(car?.owner?.name ?? "No owner")")
        print("----------------------------")
        // Задание 6
        print("Задание 6")
        // Создаю массив животных
        let animals: [Animal] = [Dog(), Cat(), Dog()]
            // Делаю перебор
        for animal in animals{
                animal.speak()
        }

    }
}
