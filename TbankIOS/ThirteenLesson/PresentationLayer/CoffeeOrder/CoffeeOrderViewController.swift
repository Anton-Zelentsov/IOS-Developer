import UIKit

protocol ICoffeeOrderView: AnyObject {
    func displayCoffees(_ coffees: [Coffee])
    func displayOrderSuccess(_ order: Order)
    func displayOrderStatus(_ order: Order)
    func displayCancelOrderSuccess()
    func displayError(_ error: Error)
    func showLoading(_ isLoading: Bool)
}

final class CoffeeOrderViewController: UIViewController, ICoffeeOrderView {
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        return tableView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee Menu"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        return indicator
    }()
    
    private let orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Place Order", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.isEnabled = false
        button.alpha = 0.6
        return button
    }()
    
    private let orderActionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let orderStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check Order Status", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        button.alpha = 0.6
        return button
    }()
    
    private let cancelOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel Order", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        button.alpha = 0.6
        return button
    }()
    
    private let orderInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private let orderIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    // MARK: - Properties
    
    private var coffees: [Coffee] = []
    private var selectedCoffee: Coffee?
    private var currentOrder: Order?

    // Dependecies
    private let presenter: ICoffeeOrderPresenter

    init(presenter: ICoffeeOrderPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        title = "Coffee Shop"
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        // Register cell
        tableView.register(CoffeeCell.self, forCellReuseIdentifier: "CoffeeCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add subviews
        view.addSubview(headerView)
        headerView.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(orderButton)
        view.addSubview(orderActionsStackView)
        orderActionsStackView.addArrangedSubview(orderStatusButton)
        orderActionsStackView.addArrangedSubview(cancelOrderButton)
        view.addSubview(orderInfoView)
        orderInfoView.addSubview(orderIdLabel)
        view.addSubview(activityIndicator)
        
        // Set up actions
        orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        orderStatusButton.addTarget(self, action: #selector(orderStatusButtonTapped), for: .touchUpInside)
        cancelOrderButton.addTarget(self, action: #selector(cancelOrderButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }

    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderActionsStackView.translatesAutoresizingMaskIntoConstraints = false
        orderInfoView.translatesAutoresizingMaskIntoConstraints = false
        orderIdLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Header view
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            // Header label
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            // Order button
            orderButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            orderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orderButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            orderButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Order info view
            orderInfoView.topAnchor.constraint(equalTo: orderButton.bottomAnchor, constant: 16),
            orderInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            orderInfoView.heightAnchor.constraint(equalToConstant: 50),
            
            // Order ID label
            orderIdLabel.centerYAnchor.constraint(equalTo: orderInfoView.centerYAnchor),
            orderIdLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 16),
            orderIdLabel.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -16),
            
            // Order actions stack view
            orderActionsStackView.topAnchor.constraint(equalTo: orderInfoView.bottomAnchor, constant: 16),
            orderActionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderActionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            orderActionsStackView.heightAnchor.constraint(equalToConstant: 100),
            
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func orderButtonTapped() {
        guard let coffee = selectedCoffee else { return }

        let alertController = UIAlertController(
            title: "Place Order",
            message: "Enter order details for \(coffee.name)",
            preferredStyle: .alert
        )

        alertController.addTextField { textField in
            textField.placeholder = "Quantity (1-5)"
            textField.keyboardType = .numberPad
        }

        alertController.addTextField { textField in
            textField.placeholder = "Your Name"
        }

        let orderAction = UIAlertAction(title: "Order", style: .default) { [weak self] _ in
            guard let self = self,
                  let quantityText = alertController.textFields?[0].text,
                  let quantity = Int(quantityText),
                  let customerName = alertController.textFields?[1].text,
                  !customerName.isEmpty else {
                return
            }

            self.presenter.didSelectCoffee(coffee, quantity: quantity, customerName: customerName)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(orderAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    @objc private func orderStatusButtonTapped() {
        guard let orderId = currentOrder?.id else { return }
        presenter.didRequestOrderStatus(orderId: orderId)
    }

    @objc private func cancelOrderButtonTapped() {
        guard let orderId = currentOrder?.id else { return }
        presenter.didRequestCancelOrder(orderId: orderId)
    }

    // MARK: - ICoffeeOrderView

    func displayCoffees(_ coffees: [Coffee]) {
        self.coffees = coffees
        tableView.reloadData()
    }

    func displayOrderSuccess(_ order: Order) {
        currentOrder = order
        
        // Update UI
        orderInfoView.isHidden = false
        orderIdLabel.text = "Order #\(order.id) - \(order.status.rawValue.capitalized)"
        
        // Enable buttons
        orderStatusButton.isEnabled = true
        orderStatusButton.alpha = 1.0
        cancelOrderButton.isEnabled = true
        cancelOrderButton.alpha = 1.0

        let alertController = UIAlertController(
            title: "Order Placed",
            message: "Your order #\(order.id) has been placed successfully!",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }

    func displayOrderStatus(_ order: Order) {
        // Update order info
        orderIdLabel.text = "Order #\(order.id) - \(order.status.rawValue.capitalized)"
        
        let alertController = UIAlertController(
            title: "Order #\(order.id) Status",
            message: "Status: \(order.status.rawValue.capitalized)",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }

    func displayCancelOrderSuccess() {
        let alertController = UIAlertController(
            title: "Order Cancelled",
            message: "Your order has been cancelled successfully.",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.orderStatusButton.isEnabled = false
            self?.orderStatusButton.alpha = 0.6
            self?.cancelOrderButton.isEnabled = false
            self?.cancelOrderButton.alpha = 0.6
            self?.orderInfoView.isHidden = true
            self?.currentOrder = nil
        }

        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func displayError(_ error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CoffeeOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeCell", for: indexPath) as? CoffeeCell else {
            return UITableViewCell()
        }

        let coffee = coffees[indexPath.row]
        cell.configure(with: coffee)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCoffee = coffees[indexPath.row]
        orderButton.isEnabled = true
        orderButton.alpha = 1.0
    }
}
