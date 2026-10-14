//
//  DependencyContainer.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import UIKit

class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    private init() {}
    
    // MARK: - Network Services
    
    lazy var networkService: NetworkServiceProtocol = {
        NetworkService.shared
    }()
    
    lazy var cardIdentificationService: CardIdentificationServiceProtocol = {
        CardIdentificationService(networkService: networkService)
    }()
    
    // MARK: - Repository
    
    lazy var cardRepository: CardRepositoryProtocol = {
        CardRepository(
            networkService: networkService,
            coreDataRepository: coreDataRepository,
            cacheInvalidationManager: cacheInvalidationManager
        )
    }()
    
    // MARK: - Cache
    
    lazy var cacheManager: CacheManagerProtocol = {
        CacheManager.shared
    }()
    
    // MARK: - Analytics
    
    lazy var analyticsManager: AnalyticsManagerProtocol = {
        AnalyticsManager.shared
    }()
    
    // MARK: - Core Data
    
    lazy var coreDataStack: CoreDataStack = {
        return CoreDataStack.shared
    }()
    
    lazy var coreDataRepository: CoreDataRepositoryProtocol = {
        return CoreDataRepository(coreDataStack: coreDataStack)
    }()
    
    lazy var cacheInvalidationManager: CacheInvalidationManager = {
        return CacheInvalidationManager(
            coreDataRepository: coreDataRepository,
            invalidationStrategy: .timeBased(expiryInterval: 24 * 60 * 60)
        )
    }()
    
    // MARK: - Feature-specific Factories
    
    func makeCameraViewModel() -> CameraViewModel {
        return CameraViewModel()
    }
    
    func makeResultsViewModel(capturedImage: UIImage, cardInfo: CardInfo? = nil) -> ResultsViewModel {
        let viewModel = ResultsViewModel(
            capturedImage: capturedImage,
            cardRepository: cardRepository,
            coreDataRepository: coreDataRepository,
            analyticsManager: analyticsManager
        )
        if let cardInfo = cardInfo {
            viewModel.cardInfo = cardInfo
        }
        return viewModel
    }
    
    func makeHistoryViewModel() -> HistoryViewModel {
        return HistoryViewModel(
            coreDataRepository: coreDataRepository,
            analyticsManager: analyticsManager
        )
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(
            analyticsManager: analyticsManager,
            cardRepository: cardRepository,
            cacheInvalidationManager: cacheInvalidationManager
        )
    }
}
