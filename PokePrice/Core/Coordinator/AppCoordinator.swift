//
//  AppCoordinator.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showWelcomeScreen()
    }
    
    private func showWelcomeScreen() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        addChild(welcomeCoordinator)
        welcomeCoordinator.start()
    }
}
