//
//  BaseViewController.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        // Override in subclasses
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showLoadingIndicator() {
        // Override in subclasses or use a shared loading view
    }
    
    func hideLoadingIndicator() {
        // Override in subclasses or use a shared loading view
    }
    
    deinit {
        cancellables.removeAll()
    }
}
