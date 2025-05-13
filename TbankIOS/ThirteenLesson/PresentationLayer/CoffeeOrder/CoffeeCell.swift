import UIKit

class CoffeeCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let coffeeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(coffeeImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        coffeeImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            coffeeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            coffeeImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            coffeeImageView.widthAnchor.constraint(equalToConstant: 40),
            coffeeImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: coffeeImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: coffeeImageView.trailingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with coffee: Coffee) {
        nameLabel.text = coffee.name
        priceLabel.text = "$\(String(format: "%.2f", coffee.price))"
        
        // For simplicity, using SF Symbols as coffee images
        let imageName: String
        switch coffee.name.lowercased() {
        case "espresso": imageName = "cup.and.saucer.fill"
        case "cappuccino": imageName = "cup.and.saucer.fill"
        case "latte": imageName = "mug.fill"
        case "americano": imageName = "mug"
        case "mocha": imageName = "cup.and.saucer"
        default: imageName = "cup"
        }
        coffeeImageView.image = UIImage(systemName: imageName)
    }
    
    // MARK: - Selection and Reuse
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        UIView.animate(withDuration: 0.2) {
            self.containerView.backgroundColor = selected ?
                UIColor(red: 0.95, green: 0.9, blue: 0.85, alpha: 1.0) : .white
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        priceLabel.text = nil
        coffeeImageView.image = nil
    }
}
