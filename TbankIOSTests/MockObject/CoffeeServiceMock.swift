import Foundation

final class CoffeeServiceMock: ICoffeeService {
    var isFetchedCoffees = false
    var isCorrectedOrderStatus = false
    var isCanceledOrder = false
    var isPlacedOrder = false
    
    var nextOrderId = 1000
    
    var coffees = [
        Coffee(id: 1, name: "Espresso", price: 2.5, imageURL: "espresso"),
        Coffee(id: 2, name: "Cappuccino", price: 3.5, imageURL: "cappuccino"),
        Coffee(id: 3, name: "Latte", price: 4.0, imageURL: "latte"),
        Coffee(id: 4, name: "Americano", price: 3.0, imageURL: "americano"),
        Coffee(id: 5, name: "Mocha", price: 4.5, imageURL: "mocha")
    ]
    
    var orders: [Order] = [
        Order(
            id: 1000,
            coffeeId: 1,
            quantity: 2,
            customerName: "Test",
            status: .completed,
            createdAt: Date()
        )
    ]
    
    func fetchCoffees() async throws -> [Coffee] {
        isFetchedCoffees = true
        return coffees
    }

    func getOrderStatus(orderId: Int) async throws -> Order {
        isCorrectedOrderStatus = true
        
        if let order = orders.first(where: { $0.id == orderId }) {
            return order
        } else {
            throw CoffeeError.invalidOrderId
        }
    }

    func cancelOrder(orderId: Int) async throws -> Bool {
        isCanceledOrder = true
        
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            let order = orders[index]
            
            if order.status == .cancelled {
                throw CoffeeError.orderAlreadyCancelled
            }
            
            let cancelledOrder = Order(
                id: order.id,
                coffeeId: order.coffeeId,
                quantity: order.quantity,
                customerName: order.customerName,
                status: .cancelled,
                createdAt: order.createdAt
            )
            
            orders[index] = cancelledOrder
            return true
        } else {
            throw CoffeeError.invalidOrderId
        }
    }

    func placeOrder(coffeeId: Int, quantity: Int, customerName: String) async throws -> Order {
        let orderId = nextOrderId
        nextOrderId += 1
        
        let newOrder = Order(
            id: orderId,
            coffeeId: coffeeId,
            quantity: quantity,
            customerName: customerName,
            status: .pending,
            createdAt: Date()
        )
        
        orders.append(newOrder)
        
        isPlacedOrder = true
        return newOrder
    }
}
