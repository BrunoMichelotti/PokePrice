//
//  SettingsCoordinator.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import UIKit

class SettingsCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: Implement Settings feature
        // let settingsViewController = SettingsViewController()
        // navigationController.pushViewController(settingsViewController, animated: true)
    }
}
