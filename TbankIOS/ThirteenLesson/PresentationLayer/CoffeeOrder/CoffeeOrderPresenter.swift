import Foundation

protocol ICoffeeOrderPresenter {
    func viewDidLoad()
    func didSelectCoffee(_ coffee: Coffee, quantity: Int, customerName: String)
    func didRequestOrderStatus(orderId: Int)
    func didRequestCancelOrder(orderId: Int)
}

final class CoffeeOrderPresenter: ICoffeeOrderPresenter {
    
    // MARK: - Properties
    
    weak var view: ICoffeeOrderView?
    private let coffeeService: ICoffeeService
    
    // MARK: - Init
    
    init(
        coffeeService: ICoffeeService
    ) {
        self.coffeeService = coffeeService
    }
    
    func viewDidLoad() {
        fetchCoffees()
    }
    
    func didSelectCoffee(_ coffee: Coffee, quantity: Int, customerName: String) {
        placeOrder(coffeeId: coffee.id, quantity: quantity, customerName: customerName)
    }
    
    func didRequestOrderStatus(orderId: Int) {
        getOrderStatus(orderId: orderId)
    }
    
    func didRequestCancelOrder(orderId: Int) {
        cancelOrder(orderId: orderId)
    }
    
    private func fetchCoffees() {
        view?.showLoading(true)
        
        Task {
            do {
                let coffees = try await coffeeService.fetchCoffees()
                await MainActor.run {
                    view?.showLoading(false)
                    view?.displayCoffees(coffees)
                }
            } catch {
                await MainActor.run {
                    view?.showLoading(false)
                    view?.displayError(error)
                }
            }
        }
    }
    
    private func placeOrder(coffeeId: Int, quantity: Int, customerName: String) {
        view?.showLoading(true)
        
        Task {
            do {
                let order = try await coffeeService.placeOrder(
                    coffeeId: coffeeId,
                    quantity: quantity,
                    customerName: customerName
                )
                await MainActor.run {
                    view?.showLoading(false)
                    view?.displayOrderSuccess(order)
                }
            } catch {
                await MainActor.run {
                    view?.showLoading(false)
                    view?.displayError(error)
                }
            }
        }
    }
    
    private func getOrderStatus(orderId: Int) {
        view?.showLoading(true)
        
        Task {
            do {
                let order = try await coffeeService.getOrderStatus(orderId: orderId)
                await MainActor.run {
                    view?.showLoading(false)
                    view?.displayOrderStatus(order)
                }
            } catch {
                await MainActor.run {
                    view?.showLoading(false)
                    view?.displayError(error)
                }
            }
        }
    }
    
    private func cancelOrder(orderId: Int) {
        view?.showLoading(true)
        
        Task {
            do {
                let success = try await coffeeService.cancelOrder(orderId: orderId)
                await MainActor.run {
                    view?.showLoading(false)
                    if success {
                        view?.displayCancelOrderSuccess()
                    }
                }
            } catch {
                await MainActor.run {
                    view?.showLoading(false)
                    view?.displayError(error)
                }
            }
        }
    }
}
