import UIKit
import Alamofire

class ImageLoaderView: UIView {
    
    // UI элементы
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Images", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.backgroundColor = UIColor(white: 0, alpha: 0.7)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // Image_URLS
    private let imageUrls = [
        "https://www.alleycat.org/wp-content/uploads/2016/06/Day-32-Denby.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM40vdTgBHqzHhMSfGHa06-7kR6vsFxEbHAg&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6PrxMYTq5vrDjYPYr5mb1FY_1pAWmcQkssA&s"
    ]
    
    // Жизненный цикл
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Setup
    private func setupUI() {
        backgroundColor = .white
        
        stackView.addArrangedSubview(imageView1)
        stackView.addArrangedSubview(imageView2)
        stackView.addArrangedSubview(imageView3)
        
        addSubview(stackView)
        addSubview(loadButton)
        addSubview(activityIndicator)
        
        loadButton.addTarget(self, action: #selector(loadImages), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            
            loadButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            loadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadButton.widthAnchor.constraint(equalToConstant: 200),
            loadButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    // Image_Loading
    @objc private func loadImages() {
        // Сбрасываю изображения
        imageView1.image = nil
        imageView2.image = nil
        imageView3.image = nil
        
        // Индикатор activity
        activityIndicator.startAnimating()
        isUserInteractionEnabled = false
        
        // Создаю group отправки для отслеживания завершения всех загрузок
        let group = DispatchGroup()
        
        // Загружаю каждую картинку
        for (index, urlString) in imageUrls.enumerated() {
            group.enter()
            
            AF.request(urlString).responseData { [weak self] response in
                defer { group.leave() }
                
                guard let self = self else { return }
                
                switch response.result {
                case .success(let data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        switch index {
                        case 0: self.imageView1.image = image
                        case 1: self.imageView2.image = image
                        case 2: self.imageView3.image = image
                        default: break
                        }
                    }
                case .failure(let error):
                    print("Error loading image \(index): \(error.localizedDescription)")
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.isUserInteractionEnabled = true
        }
    }
}

