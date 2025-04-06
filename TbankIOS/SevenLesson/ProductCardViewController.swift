import UIKit

struct Product {
    let brand: String
    let name: String
    let currentPrice: String
    let oldPrice: String?
    let imageName: String
}

class ProductCardViewController: UIViewController {
    
    private var currentProductIndex = 0
    
    private let products: [Product] = [
        Product(brand: "TOMMY HILFIGER",
               name: "Мужские кроссовки Essential Leather",
               currentPrice: "9 600 ₽",
               oldPrice: "19 190 ₽",
               imageName: "EssentialLeather"),
        Product(brand: "NIKE",
               name: "Кроссовки Air force 1",
               currentPrice: "12 990 ₽",
               oldPrice: "15 990 ₽",
               imageName: "Airforce1"),
        Product(brand: "ADIDAS",
               name: "Кроссовки YEEZY BOOST 350 V2",
               currentPrice: "14 999 ₽",
               oldPrice: "17 999 ₽",
               imageName: "YeezyBoost350V2"),
        Product(brand: "PUMA",
               name: "Кроссовки RS-X",
               currentPrice: "8 490 ₽",
               oldPrice: "10 990 ₽",
               imageName: "RSX"),
        Product(brand: "REEBOK",
               name: "Кроссовки Classic Leather",
               currentPrice: "7 990 ₽",
               oldPrice: nil,
               imageName: "ClassicLeather")
    ]
    
    // UI элементы
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    // Бренд
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Название
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Ценник
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    // Текущая цена
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Кнопка
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать следующий товар", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // Жизненный цикл контролера
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        updateProductCard()
        
        nextButton.addTarget(self, action: #selector(showNextProduct), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(productImageView)
        view.addSubview(brandLabel)
        view.addSubview(nameLabel)
        view.addSubview(priceStackView)
        view.addSubview(nextButton)
    }
    // Констрейны: картинка, бренд, ценник, кнопка
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            productImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            
            brandLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            brandLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priceStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            priceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateProductCard() {
        let product = products[currentProductIndex]
        
        productImageView.image = UIImage(named: product.imageName)
        brandLabel.text = product.brand
        nameLabel.text = product.name
        currentPriceLabel.text = product.currentPrice
        
        // Очищаю основную память (стек) с ценниками
        priceStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        priceStackView.addArrangedSubview(currentPriceLabel)
        
        // Добавляю старую цену, если она есть, нет старой цены только у REEBOK
        if let oldPrice = product.oldPrice {
            let oldPriceLabel = UILabel()
            oldPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            oldPriceLabel.textColor = .gray
            let attributedString = NSMutableAttributedString(string: oldPrice)
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributedString.length)
            )
            oldPriceLabel.attributedText = attributedString
            priceStackView.addArrangedSubview(oldPriceLabel)
        }
    }
    
    @objc private func showNextProduct() {
        currentProductIndex = (currentProductIndex + 1) % products.count
        updateProductCard()
    }
}
