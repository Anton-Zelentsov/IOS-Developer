import Foundation

enum OrderStatus: String, Codable {
    case pending
    case preparing
    case ready
    case completed
    case cancelled
}
