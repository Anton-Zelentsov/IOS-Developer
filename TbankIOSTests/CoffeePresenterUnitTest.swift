import XCTest
@testable import TbankIOS

final class CoffeePresenterUnitTest: XCTestCase {
    private let mockCoffee = Coffee(id: 1, name: "Espresso", price: 2.5, imageURL: "")
    private var sut: CoffeeOrderPresenter!
    private var coffeeServiceMock: ICoffeeService!
    private var view: CoffeeViewMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        coffeeServiceMock = CoffeeServiceMock()
        view = CoffeeViewMock()
        sut = CoffeeOrderPresenter(coffeeService: coffeeServiceMock)
        sut.view = view
    }

    override func tearDownWithError() throws {
        sut = nil
        coffeeServiceMock = nil
        view = nil
        try super.tearDownWithError()
    }

    func test_viewDidLoad() async throws {
        let expectation = expectation(description: "Coffees loaded")
        view.onDisplayCoffees = {
            expectation.fulfill()
        }

        sut.viewDidLoad()
        await fulfillment(of: [expectation], timeout: 2.0)

        XCTAssertTrue(view.isDisplayedLoad)
        XCTAssertTrue(view.showCoffees)
        XCTAssertFalse(view.showError)
    }

    func test_didSelectCoffee() async throws {
        let expectation = expectation(description: "Order placed")
        view.onDisplayOrderSuccess = {
            expectation.fulfill()
        }

        sut.didSelectCoffee(mockCoffee, quantity: 1, customerName: "Test User")
        await fulfillment(of: [expectation], timeout: 2.0)

        XCTAssertTrue(view.isDisplayedLoad)
        XCTAssertTrue(view.showOrderSuccess)
        XCTAssertFalse(view.showError)
    }

    func test_didRequestOrderStatus() async throws {
        let order = try await coffeeServiceMock.placeOrder(
            coffeeId: mockCoffee.id,
            quantity: 1,
            customerName: "Test"
        )
        
        let expectation = expectation(description: "Order status returned")
        view.onDisplayOrderStatus = {
            expectation.fulfill()
        }

        sut.didRequestOrderStatus(orderId: order.id)
        await fulfillment(of: [expectation], timeout: 2.0)

        XCTAssertTrue(view.isDisplayedLoad)
        XCTAssertTrue(view.showOrderStatus)
        XCTAssertFalse(view.showError)
    }

    func test_didRequestCancelOrder() async throws {
        let order = try await coffeeServiceMock.placeOrder(
            coffeeId: mockCoffee.id,
            quantity: 1,
            customerName: "Test"
        )
        
        let expectation = expectation(description: "Order cancelled")
        view.onDisplayOrderSuccess = {
            expectation.fulfill()
        }

        sut.didRequestCancelOrder(orderId: order.id)
        await fulfillment(of: [expectation], timeout: 2.0)

        XCTAssertTrue(view.isDisplayedLoad)
        XCTAssertTrue(view.showOrderSuccess)
        XCTAssertFalse(view.showError)
    }
}
