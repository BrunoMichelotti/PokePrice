//
//  SettingsViewModel.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import Combine

class SettingsViewModel: BaseViewModel {
    
    private let analyticsManager: AnalyticsManagerProtocol
    private let cardRepository: CardRepositoryProtocol
    private let cacheInvalidationManager: CacheInvalidationManager
    
    @Published var selectedCurrency: String = "BRL"
    @Published var enableCache: Bool = true
    @Published var cacheSize: CacheSize?
    
    init(analyticsManager: AnalyticsManagerProtocol = DependencyContainer.shared.analyticsManager,
         cardRepository: CardRepositoryProtocol = DependencyContainer.shared.cardRepository,
         cacheInvalidationManager: CacheInvalidationManager = DependencyContainer.shared.cacheInvalidationManager) {
        self.analyticsManager = analyticsManager
        self.cardRepository = cardRepository
        self.cacheInvalidationManager = cacheInvalidationManager
        super.init()
        loadSettings()
        loadCacheSize()
    }
    
    private func loadSettings() {
        // TODO: Load settings from UserDefaults
    }
    
    private func loadCacheSize() {
        Task {
            do {
                let size = try await cardRepository.getCacheSize()
                await MainActor.run {
                    self.cacheSize = size
                }
            } catch {
                await MainActor.run {
                    self.analyticsManager.logError(error)
                }
            }
        }
    }
    
    func updateCurrency(_ currency: String) {
        selectedCurrency = currency
        analyticsManager.logUserAction(action: "currency_changed", parameters: ["currency": currency])
        // TODO: Save to UserDefaults
    }
    
    func toggleCache(_ enabled: Bool) {
        enableCache = enabled
        if !enabled {
            Task {
                do {
                    try await cardRepository.clearAllCache()
                    analyticsManager.logUserAction(action: "cache_cleared", parameters: nil)
                    loadCacheSize()
                } catch {
                    await MainActor.run {
                        self.showError(error.localizedDescription)
                        self.analyticsManager.logError(error)
                    }
                }
            }
        }
        // TODO: Save to UserDefaults
    }
    
    func clearCache() {
        Task {
            do {
                try await cardRepository.clearAllCache()
                analyticsManager.logUserAction(action: "cache_cleared", parameters: nil)
                loadCacheSize()
            } catch {
                await MainActor.run {
                    self.showError(error.localizedDescription)
                    self.analyticsManager.logError(error)
                }
            }
        }
    }
    
    func performCacheMaintenance() {
        Task {
            do {
                try await cardRepository.performCacheMaintenance()
                analyticsManager.logUserAction(action: "cache_maintenance", parameters: nil)
                loadCacheSize()
            } catch {
                await MainActor.run {
                    self.showError(error.localizedDescription)
                    self.analyticsManager.logError(error)
                }
            }
        }
    }
}
