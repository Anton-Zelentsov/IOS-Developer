import Foundation

protocol ICoffeeService {
    func fetchCoffees() async throws -> [Coffee]
    func getOrderStatus(orderId: Int) async throws -> Order
    func cancelOrder(orderId: Int) async throws -> Bool
    func placeOrder(
        coffeeId: Int,
        quantity: Int,
        customerName: String
    ) async throws -> Order
}

// MARK: - Errors

enum CoffeeError: Error {
    case invalidOrderId
    case orderAlreadyCancelled
}

// MARK: - Service

final class CoffeeService: ICoffeeService {
    
    // In-memory storage for mock data
    private var availableCoffees: [Coffee] = []
    private var orders: [Order] = []
    private var nextOrderId = 1000
    
    init() {
        // Prepare mock coffee data
        availableCoffees = [
            Coffee(id: 1, name: "Espresso", price: 2.5, imageURL: "espresso"),
            Coffee(id: 2, name: "Cappuccino", price: 3.5, imageURL: "cappuccino"),
            Coffee(id: 3, name: "Latte", price: 4.0, imageURL: "latte"),
            Coffee(id: 4, name: "Americano", price: 3.0, imageURL: "americano"),
            Coffee(id: 5, name: "Mocha", price: 4.5, imageURL: "mocha")
        ]
    }
    
    // Simulates fetching available coffees
    func fetchCoffees() async throws -> [Coffee] {
        // Simulate network delay
        try await Task.sleep(for: .seconds(0.5))
        
        return availableCoffees
    }
    
    // Places a new coffee order
    func placeOrder(
        coffeeId: Int,
        quantity: Int,
        customerName: String
    ) async throws -> Order {
        // Simulate network delay
        try await Task.sleep(for: .seconds(1.0))
        
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
        return newOrder
    }
    
    // Gets the status of an existing order
    func getOrderStatus(orderId: Int) async throws -> Order {
        // Simulate network delay
        try await Task.sleep(for: .seconds(0.7))
        
        if let order = orders.first(where: { $0.id == orderId }) {
            return order
        } else {
            throw CoffeeError.invalidOrderId
        }
    }
    
    // Cancels an existing order
    func cancelOrder(orderId: Int) async throws -> Bool {
        // Simulate network delay
        try await Task.sleep(for: .seconds(0.8))
        
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
}
