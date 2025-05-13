import XCTest
@testable import TbankIOS

final class CoffeeServiceUnitTest: XCTestCase {
    private var sut: CoffeeServiceMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CoffeeServiceMock()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_fetchCoffees() async {
        _ = try? await sut.fetchCoffees()
        XCTAssertTrue(sut.isFetchedCoffees)
    }
    
    func test_getOrderStatus() async {
        if let order = sut.orders.first {
            _ = try? await sut.getOrderStatus(orderId: order.id)
        } else {
            XCTAssertFalse(sut.orders.isEmpty)
        }
        XCTAssertTrue(sut.isCorrectedOrderStatus)
    }
    
    func test_throwsOrderAlreadyCancelled() async throws {
        guard let orderId = sut.orders.first?.id else {
            XCTFail("orders is empty")
            return
        }
        _ = try await sut.cancelOrder(orderId: orderId)
        
        do {
            _ = try await sut.cancelOrder(orderId: orderId)
            XCTFail("orderAlreadyCancelled error")
        } catch {
            XCTAssertEqual(error as? CoffeeError, CoffeeError.orderAlreadyCancelled)
        }
    }
    
    func test_cancelOrder() async {
        if let order = sut.orders.first {
            _ = try? await sut.cancelOrder(orderId: order.id)
        } else {
            XCTAssertFalse(sut.orders.isEmpty)
        }
        XCTAssertTrue(sut.isCanceledOrder)
    }
    
    func test_updatesOrderStatusToCancelled() async throws {
        guard let orderId = sut.orders.first?.id else {
            XCTFail("orders is empty")
            return
        }
        
        _ = try await sut.cancelOrder(orderId: orderId)
        let updatedOrder = try await sut.getOrderStatus(orderId: orderId)
        XCTAssertEqual(updatedOrder.status, .cancelled)
    }
    
    func test_placeOrder() async {
        if let order = sut.orders.first {
            _ = try? await sut.placeOrder(
                coffeeId: order.coffeeId,
                quantity: order.quantity,
                customerName: order.customerName
            )
        } else {
            XCTAssertFalse(sut.orders.isEmpty)
        }
        XCTAssertTrue(sut.isPlacedOrder)
    }
    
    func test_returnsExpectedCoffees() async throws {
        let coffees = try await sut.fetchCoffees()
        XCTAssertEqual(coffees.count, 5)
        XCTAssertEqual(coffees[0].name, "Espresso")
    }
}
