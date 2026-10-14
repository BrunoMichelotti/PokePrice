//
//  ResultsCoordinator.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import UIKit

class ResultsCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let capturedImage: UIImage
    private let cardInfo: CardInfo?
    private let dependencyContainer: DependencyContainer
    
    init(navigationController: UINavigationController, capturedImage: UIImage, cardInfo: CardInfo? = nil, dependencyContainer: DependencyContainer = .shared) {
        self.navigationController = navigationController
        self.capturedImage = capturedImage
        self.cardInfo = cardInfo
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        let resultsViewModel = dependencyContainer.makeResultsViewModel(capturedImage: capturedImage, cardInfo: cardInfo)
        
        let resultsViewController = ResultsViewController(viewModel: resultsViewModel)
        resultsViewController.coordinator = self
        navigationController.pushViewController(resultsViewController, animated: true)
    }
    
    func showHistory() {
        let historyCoordinator = HistoryCoordinator(navigationController: navigationController)
        addChild(historyCoordinator)
        historyCoordinator.start()
    }
    
    func showSettings() {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        addChild(settingsCoordinator)
        settingsCoordinator.start()
    }
}


