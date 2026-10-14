//
//  CameraCoordinator.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import UIKit

class CameraCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var cameraViewController: CameraViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let cameraViewController = CameraViewController()
        self.cameraViewController = cameraViewController
        cameraViewController.coordinator = self
        navigationController.pushViewController(cameraViewController, animated: true)
    }
    
    func showResults(with image: UIImage, cardInfo: CardInfo? = nil) {
        let resultsCoordinator = ResultsCoordinator(
            navigationController: navigationController,
            capturedImage: image,
            cardInfo: cardInfo,
            dependencyContainer: DependencyContainer.shared
        )
        addChild(resultsCoordinator)
        resultsCoordinator.start()
    }
    
    func showManualSearch() {
        // TODO: Implement manual search flow
    }
}


