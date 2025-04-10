import UIKit

struct Product {
    let brand: String
    let name: String
    let currentPrice: String
    let oldPrice: String?
    let imageName: String?
}

class ProductCardViewController: UIViewController {
    
    private var selectedProductIndex = 0
    
    private let products: [Product] = [
        Product(
            brand: "TOMMY HILFIGER",
            name: "Мужские кроссовки Essential Leather",
            currentPrice: "9 600 ₽",
            oldPrice: "19 190 ₽",
            imageName: "EssentialLeather"
        ),
        Product(
            brand: "NIKE",
            name: "Кроссовки Air Force 1",
            currentPrice: "12 990 ₽",
            oldPrice: "15 990 ₽",
            imageName: "Airforce1"
        ),
        Product(
            brand: "PUMA",
            name: "Кроссовки RS-X",
            currentPrice: "8 490 ₽",
            oldPrice: "10 990 ₽",
            imageName: "RSX"
        ),
        Product(
            brand: "REEBOK",
            name: "Кроссовки Classic Leather",
            currentPrice: "7 990 ₽",
            oldPrice: nil,
            imageName: "ClassicLeather"
        )
    ]

    // UI элементы
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let brandLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceStackView = UIStackView()
    private let currentPriceLabel = UILabel()
    private let oldPriceLabel = UILabel()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать следующий товар", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupButton()
        setupConstraints()
        updateProductCard()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        // Настройка лейблов
        brandLabel.configure(fontSize: 16, weight: .semibold, color: .darkGray)
        nameLabel.configure(fontSize: 20, weight: .bold, color: .black, lines: 0)
        currentPriceLabel.configure(fontSize: 22, weight: .bold, color: .black)
        oldPriceLabel.configure(fontSize: 16, weight: .regular, color: .gray)
        
        // Настройка StackView
        priceStackView.axis = .horizontal
        priceStackView.spacing = 8
        priceStackView.alignment = .center
        
        // Добавляю лейблы цен в StackView
        priceStackView.addArrangedSubview(currentPriceLabel)
        priceStackView.addArrangedSubview(oldPriceLabel)
        
        // Добавляю все элементы на экран
        [productImageView, brandLabel, nameLabel, priceStackView, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupButton() {
        nextButton.addTarget(self, action: #selector(showNextProduct), for: .touchUpInside)
    }
    
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
        let product = products[selectedProductIndex]
        
        // Обновляю изображение продукта
        productImageView.image = UIImage(named: product.imageName ?? "")
        
        // Обновляю текстовые данные
        brandLabel.text = product.brand
        nameLabel.text = product.name
        currentPriceLabel.text = product.currentPrice
        
        // Обновляю oldPrice
        if let oldPrice = product.oldPrice {
            oldPriceLabel.attributedText = oldPrice.strikethrough()
            oldPriceLabel.isHidden = false
        } else {
            oldPriceLabel.isHidden = true
        }
    }
    
    @objc private func showNextProduct() {
        selectedProductIndex = (selectedProductIndex + 1) % products.count
        updateProductCard()
    }
}

extension UILabel {
    func configure(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, lines: Int = 1) {
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.textColor = color
        self.numberOfLines = lines
    }
}

extension String {
    func strikethrough() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: self.count)
        )
        return attributedString
    }
}

