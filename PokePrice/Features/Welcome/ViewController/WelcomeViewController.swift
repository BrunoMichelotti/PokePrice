//
//  WelcomeViewController.swift
//  PokePrice
//
//  Created by Bruno on 28/09/26.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var welcomeView: WelcomeView?
    let viewModel: WelcomeViewModel = WelcomeViewModel()
    weak var coordinator: WelcomeCoordinator?
    
    override func loadView() {
        self.welcomeView = WelcomeView()
        self.view = self.welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupWelcomeViewCallbacks()
        setupNavigation()
        
        // Log screen view
        AnalyticsManager.shared.logScreenView(screenName: "welcome_screen")
    }
    
    private func setupViewModel() {
        viewModel.setDelegate(delegate: self)
    }
    
    private func setupWelcomeViewCallbacks() {
        welcomeView?.onScanTapped = { [weak self] in
            self?.viewModel.startScanning()
        }
    }
    
    private func setupNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension WelcomeViewController: WelcomeViewModelDelegate {
    
    func navigateToCamera() {
        coordinator?.showCamera()
    }
}