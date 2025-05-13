import Foundation

struct Order: Codable, Identifiable {
    let id: Int
    let coffeeId: Int
    let quantity: Int
    let customerName: String
    let status: OrderStatus
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, coffeeId, quantity, customerName, status, createdAt
    }
}
