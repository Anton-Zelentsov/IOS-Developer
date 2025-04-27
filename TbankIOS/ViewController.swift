import UIKit

class ViewController: UIViewController {
    
    // UI элементы
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "applelogo")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Продолжить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка shadow
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0
        
        return button
    }()
    
    // Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimations()
    }
    
    // Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(actionButton)
        
        // Добавляю обработчик нажатия на кнопку
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Заголовок
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Button
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Animations
    private func startAnimations() {
        // 1. Анимация логотипа - выезжает сверху
        animateLogo()
        
        // 2. Через 0.2 сек - fade-заголовок
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateTitle()
        }
        
        // 3. Через 0.4 сек - кнопка с bounce-эффектом
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.animateButton()
            self.animateButtonShadow()
        }
    }
    
    private func animateLogo() {
        // Начальное положение - выше экрана
        logoImageView.transform = CGAffineTransform(translationX: 0, y: -200)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = .identity
        }, completion: nil)
    }
    
    private func animateTitle() {
        UIView.animate(withDuration: 0.6, animations: {
            self.titleLabel.alpha = 1
        })
    }
    
    private func animateButton() {
        // Начальное состояние - маленький размер и поворот
        actionButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5).rotated(by: .pi / 8)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.actionButton.alpha = 1
            self.actionButton.transform = .identity
        }, completion: nil)
    }
    
    private func animateButtonShadow() {
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.fromValue = 0
        shadowAnimation.toValue = 0.5
        shadowAnimation.duration = 0.5
        shadowAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        shadowAnimation.fillMode = .forwards
        shadowAnimation.isRemovedOnCompletion = false
        
        actionButton.layer.add(shadowAnimation, forKey: "shadowAnimation")
    }
    
    // Button Action
    @objc private func buttonTapped() {
        // Анимация CornerRadius при нажатии
        let originalCornerRadius = actionButton.layer.cornerRadius
        
        UIView.animate(withDuration: 0.2, animations: {
            self.actionButton.layer.cornerRadius = 25
            self.actionButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.actionButton.layer.cornerRadius = originalCornerRadius
                self.actionButton.transform = .identity
            }
        }
    }
}
