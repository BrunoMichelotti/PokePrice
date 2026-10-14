//
//  WelcomeCoordinator.swift
//  PokePrice
//
//  Created by Bruno on 28/09/26.
//

import UIKit

class WelcomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var welcomeViewController: WelcomeViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let welcomeViewController = WelcomeViewController()
        self.welcomeViewController = welcomeViewController
        welcomeViewController.coordinator = self
        navigationController.pushViewController(welcomeViewController, animated: false)
    }
    
    func showCamera() {
        let cameraCoordinator = CameraCoordinator(navigationController: navigationController)
        addChild(cameraCoordinator)
        cameraCoordinator.start()
    }
}