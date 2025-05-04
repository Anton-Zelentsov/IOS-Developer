import UIKit
import Alamofire

// Services
protocol ImageDownloadServiceProtocol {
    func downloadImages(urls: [URL], completion: @escaping ([UIImage?]) -> Void)
}

class ImageDownloadService: ImageDownloadServiceProtocol {
    func downloadImages(urls: [URL], completion: @escaping ([UIImage?]) -> Void) {
        var images: [UIImage?] = Array(repeating: nil, count: urls.count)
        let group = DispatchGroup()
        
        for (index, url) in urls.enumerated() {
            group.enter()
            
            AF.request(url).response { response in
                switch response.result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        images[index] = image
                    }
                case .failure(let error):
                    print("Error downloading image: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
}

protocol ActivityIndicatorServiceProtocol {
    func show(on view: UIView)
    func hide()
}

class ActivityIndicatorService: ActivityIndicatorServiceProtocol {
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    func show(on view: UIView) {
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hide() {
        print("hide", activityIndicator)
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

// Loader_Model
struct ImageLoaderModel {
    let imageURLs: [URL]
    
    static var defaultURLs: [URL] {
        return [
            URL(string: "https://www.alleycat.org/wp-content/uploads/2016/06/Day-32-Denby.jpg")!,
            URL(string: "https://cataas.com/cat")!,
            URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6PrxMYTq5vrDjYPYr5mb1FY_1pAWmcQkssA&s")!
        ]
    }
}

// View_Model
protocol ImageLoaderViewModelProtocol {
    var didUpdateImages: (([UIImage?]) -> Void)? { get set }
    var didToggleLoading: ((Bool) -> Void)? { get set }
    func loadImages()
}

class ImageLoaderViewModel: ImageLoaderViewModelProtocol {
    private let imageDownloadService: ImageDownloadServiceProtocol
    private let activityIndicatorService: ActivityIndicatorServiceProtocol
    private let model: ImageLoaderModel
    
    var didUpdateImages: (([UIImage?]) -> Void)?
    var didToggleLoading: ((Bool) -> Void)?
    
    init(model: ImageLoaderModel = ImageLoaderModel(imageURLs: ImageLoaderModel.defaultURLs),
         imageDownloadService: ImageDownloadServiceProtocol = ImageDownloadService(),
         activityIndicatorService: ActivityIndicatorServiceProtocol = ActivityIndicatorService()) {
        self.model = model
        self.imageDownloadService = imageDownloadService
        self.activityIndicatorService = activityIndicatorService
    }
    
    func loadImages() {
        didToggleLoading?(true)
        
        imageDownloadService.downloadImages(urls: model.imageURLs) { [weak self] images in
            self?.didToggleLoading?(false)
            self?.didUpdateImages?(images)
        }
    }
}

// View
class ImageLoaderViewController: UIViewController {
    private var viewModel: ImageLoaderViewModelProtocol
    private let imageViews: [UIImageView]
    private let loadButton: UIButton
    
    init(viewModel: ImageLoaderViewModelProtocol = ImageLoaderViewModel()) {
        self.viewModel = viewModel
        self.imageViews = (0..<3).map { _ in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .lightGray
            return imageView
        }
        self.loadButton = UIButton(type: .system)
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Настройка вида изображения
        let stackView = UIStackView(arrangedSubviews: imageViews)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // Настройка кнопки
        loadButton.setTitle("Load Images", for: .normal)
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: loadButton.topAnchor, constant: -20),
            
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        let activityIndicatorService = ActivityIndicatorService()
        viewModel.didUpdateImages = { [weak self] images in
            DispatchQueue.main.async {
                guard let self = self else { return }
                for (index, image) in images.enumerated() {
                    self.imageViews[index].image = image
                }
            }
        }
        
        viewModel.didToggleLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if isLoading {
                    activityIndicatorService.show(on: self.view)
                } else {
                    activityIndicatorService.hide()
                }
            }
        }
    }
    
    @objc private func loadButtonTapped() {
        viewModel.loadImages()
    }
}

