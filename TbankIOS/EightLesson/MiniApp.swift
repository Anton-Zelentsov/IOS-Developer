import UIKit

// Модель данных
struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    struct Rating: Decodable {
        let rate: Double
        let count: Int
    }
}

// Протоколы
protocol ImageListViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func updateProgress(total: Int, downloaded: Int, progress: Float)
    func reloadData()
    func showError(message: String)
}

protocol ImageListPresenterProtocol: AnyObject {
    var numberOfProducts: Int { get }
    func viewDidLoad()
    func product(at index: Int) -> Product
    func imageData(for product: Product) -> Data?
}

protocol NetworkServiceProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func downloadImage(from urlString: String, delegate: URLSessionDataDelegate)
}

// Сетевой сервис
final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://fakestoreapi.com"
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/products") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    completion(.success(products))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, delegate: URLSessionDataDelegate) {
        guard let url = URL(string: urlString) else { return }
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        session.dataTask(with: url).resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case imageDownloadFailed
}

// Presenter
final class ImageListPresenter: NSObject, ImageListPresenterProtocol, URLSessionDataDelegate {
    weak var view: ImageListViewProtocol?
    var networkService: NetworkServiceProtocol
    private var products: [Product] = []
    private var imageDataCache: NSCache<NSString, NSData> = {
        let cache = NSCache<NSString, NSData>()
        cache.countLimit = 50
        return cache
    }()
    private var downloadProgress: [String: Float] = [:]
    private var totalImagesToDownload = 0
    private var downloadedImagesCount = 0
    private let synchronizationQueue = DispatchQueue(label: "com.imageLoader.cacheQueue", attributes: .concurrent)
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    var numberOfProducts: Int {
        return products.count
    }
    
    func product(at index: Int) -> Product {
        return products[index]
    }
    
    func imageData(for product: Product) -> Data? {
        var data: Data?
        synchronizationQueue.sync {
            data = imageDataCache.object(forKey: product.image as NSString) as Data?
        }
        return data
    }
    
    func viewDidLoad() {
        view?.showLoading()
        networkService.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.startDownloadingImages(products: products)
                    self?.view?.reloadData()
                case .failure(let error):
                    self?.view?.showError(message: "Ошибка загрузки: \(error.localizedDescription)")
                }
                self?.view?.hideLoading()
            }
        }
    }
    
    private func startDownloadingImages(products: [Product]) {
        totalImagesToDownload = products.count
        downloadedImagesCount = 0
        downloadProgress.removeAll()
        
        products.forEach { product in
            downloadProgress[product.image] = 0.0
            networkService.downloadImage(from: product.image, delegate: self)
        }
    }
    
    // URL_Session_Data_Delegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let url = dataTask.originalRequest?.url?.absoluteString else { return }
        
        synchronizationQueue.async(flags: .barrier) { [weak self] in
            if let cachedData = self?.imageDataCache.object(forKey: url as NSString) {
                let combinedData = cachedData as Data + data
                self?.imageDataCache.setObject(combinedData as NSData, forKey: url as NSString)
            } else {
                self?.imageDataCache.setObject(data as NSData, forKey: url as NSString)
            }
        }
        
        let progress: Float
        if let httpResponse = dataTask.response as? HTTPURLResponse,
           httpResponse.statusCode == 200,
           let expected = dataTask.response?.expectedContentLength,
           expected > 0 {
            progress = Float(data.count) / Float(expected)
        } else {
            progress = min(Float(data.count) / 500_000, 0.95)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.downloadProgress[url] = progress
            self?.updateOverallProgress()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url?.absoluteString else { return }
        
        DispatchQueue.main.async { [weak self] in
            if error == nil {
                self?.downloadedImagesCount += 1
                self?.downloadProgress[url] = 1.0
            } else {
                self?.downloadProgress[url] = 0.0
            }
            self?.updateOverallProgress()
            self?.view?.reloadData()
        }
    }
    
    private func updateOverallProgress() {
        guard !downloadProgress.isEmpty else { return }
        
        let totalProgress = downloadProgress.values.reduce(0, +) / Float(downloadProgress.count)
        let downloaded = downloadProgress.values.filter { $0 >= 0.99 }.count
        
        view?.updateProgress(
            total: downloadProgress.count,
            downloaded: downloaded,
            progress: min(totalProgress, 1.0)
        )
    }
}

// Assembler module
final class ImageListModuleAssembler {
    static func assemble() -> UIViewController {
        let view = ImageListViewController()
        let networkService = NetworkService()
        let presenter = ImageListPresenter(networkService: networkService)
        
        view.presenter = presenter
        presenter.view = view
        
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}

// View Controller
final class ImageListViewController: UIViewController {
    var presenter: ImageListPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 80
        table.translatesAutoresizingMaskIntoConstraints = false
        table.refreshControl = refreshControl
        return table
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = .systemGray5
        progress.progressTintColor = .systemBlue
        return progress
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Товары"
        
        let progressStack = UIStackView(arrangedSubviews: [progressView, progressLabel])
        progressStack.axis = .vertical
        progressStack.spacing = 4
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(progressStack)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            progressStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progressStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: progressStack.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func refreshData() {
        presenter.viewDidLoad()
        refreshControl.endRefreshing()
    }
}

extension ImageListViewController: ImageListViewProtocol {
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func updateProgress(total: Int, downloaded: Int, progress: Float) {
        progressView.setProgress(progress, animated: true)
        progressLabel.text = "Загружено \(downloaded) из \(total) (\(Int(progress * 100))%)"
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// Product cell
final class ProductCell: UITableViewCell {
    static let reuseIdentifier = "ProductCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    func configure(with product: Product, imageData: Data?) {
        var content = defaultContentConfiguration()
        content.text = product.title
        content.secondaryText = "\(product.price) $"
        content.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        content.secondaryTextProperties.color = .systemGreen
        
        if let imageData = imageData, let image = UIImage(data: imageData) {
            content.image = image
            content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
            content.imageProperties.cornerRadius = 8
        } else {
            content.image = UIImage(systemName: "photo")
        }
        
        contentConfiguration = content
    }
}

// TableView DataSource and Delegate
extension ImageListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        let product = presenter.product(at: indexPath.row)
        cell.configure(with: product, imageData: presenter.imageData(for: product))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
