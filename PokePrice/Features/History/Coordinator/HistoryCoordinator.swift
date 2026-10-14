//
//  HistoryCoordinator.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import UIKit

class HistoryCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: Implement History feature
        // let historyViewController = HistoryViewController()
        // navigationController.pushViewController(historyViewController, animated: true)
    }
}
