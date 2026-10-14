//
//  HistoryViewModel.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import Combine

class HistoryViewModel: BaseViewModel {
    
    private let coreDataRepository: CoreDataRepositoryProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    
    @Published var historyItems: [HistoryItem] = []
    
    init(coreDataRepository: CoreDataRepositoryProtocol = DependencyContainer.shared.coreDataRepository,
         analyticsManager: AnalyticsManagerProtocol = DependencyContainer.shared.analyticsManager) {
        self.coreDataRepository = coreDataRepository
        self.analyticsManager = analyticsManager
        super.init()
    }
    
    func loadHistory(limit: Int? = nil) {
        isLoading = true
        
        Task {
            do {
                let history = try await coreDataRepository.getHistory(limit: limit)
                
                await MainActor.run {
                    self.historyItems = history
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.showError(error.localizedDescription)
                    self.analyticsManager.logError(error)
                }
            }
        }
    }
    
    func deleteHistoryItem(historyId: String) {
        Task {
            do {
                try await coreDataRepository.deleteHistoryItem(historyId: historyId)
                analyticsManager.logUserAction(action: "history_item_deleted", parameters: ["historyId": historyId])
                
                // Reload history
                loadHistory()
            } catch {
                await MainActor.run {
                    self.showError(error.localizedDescription)
                    self.analyticsManager.logError(error)
                }
            }
        }
    }
    
    func clearAllHistory() {
        Task {
            do {
                try await coreDataRepository.clearHistory()
                analyticsManager.logUserAction(action: "history_cleared", parameters: nil)
                
                // Reload history
                loadHistory()
            } catch {
                await MainActor.run {
                    self.showError(error.localizedDescription)
                    self.analyticsManager.logError(error)
                }
            }
        }
    }
}
