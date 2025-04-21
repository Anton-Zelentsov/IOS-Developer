import UIKit

class ViewController: UIViewController {
    
    private let imageLoaderView = ImageLoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageLoaderView()
    }
    
    private func setupImageLoaderView() {
        view.addSubview(imageLoaderView)
        imageLoaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageLoaderView.topAnchor.constraint(equalTo: view.topAnchor),
            imageLoaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageLoaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageLoaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

