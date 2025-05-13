import Foundation

final class CoffeeViewMock: ICoffeeOrderView {
    var showCoffees = false
    var showOrderSuccess = false
    var showOrderStatus = false
    var showError = false
    var isDisplayedLoad = false

    var onDisplayCoffees: (() -> Void)?
    var onDisplayOrderSuccess: (() -> Void)?
    var onDisplayOrderStatus: (() -> Void)?
    var onDisplayError: (() -> Void)?

    func showLoading(_ loading: Bool) {
        isDisplayedLoad = true
    }

    func displayCoffees(_ coffees: [Coffee]) {
        showCoffees = true
        onDisplayCoffees?()
    }

    func displayOrderSuccess(_ order: Order) {
        showOrderSuccess = true
        onDisplayOrderSuccess?()
    }

    func displayOrderStatus(_ order: Order) {
        showOrderStatus = true
        onDisplayOrderStatus?()
    }

    func displayError(_ error: Error) {
        showError = true
        onDisplayError?()
    }

    func displayCancelOrderSuccess() {
        showOrderSuccess = true
        onDisplayOrderSuccess?()
    }
}
