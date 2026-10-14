//
//  ResultsViewModel.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation
import UIKit
import Combine

protocol ResultsViewModelDelegate: AnyObject {
    func cardIdentificationCompleted(card: CardInfo)
    func pricingDataLoaded(pricing: PricingData)
    func errorOccurred(error: Error)
}

class ResultsViewModel: BaseViewModel {
    
    weak var delegate: ResultsViewModelDelegate?
    
    let capturedImage: UIImage
    var cardInfo: CardInfo?
    var pricingData: PricingData?
    
    private let cardRepository: CardRepositoryProtocol
    private let coreDataRepository: CoreDataRepositoryProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    
    init(capturedImage: UIImage, 
         cardRepository: CardRepositoryProtocol = DependencyContainer.shared.cardRepository,
         coreDataRepository: CoreDataRepositoryProtocol = DependencyContainer.shared.coreDataRepository,
         analyticsManager: AnalyticsManagerProtocol = DependencyContainer.shared.analyticsManager) {
        self.capturedImage = capturedImage
        self.cardRepository = cardRepository
        self.coreDataRepository = coreDataRepository
        self.analyticsManager = analyticsManager
    }
    
    func setDelegate(delegate: ResultsViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func processCard() {
        isLoading = true
        
        // TODO: Integrate with backend for card identification
        // For now, use mock data
        let mockCardInfo = CardInfo(
            id: "mock_card_123",
            name: "Charizard ex",
            setName: "Obsidian Flames",
            setCode: "SVP",
            cardNumber: "215/196",
            rarity: "Ultra Rare",
            condition: "Near Mint",
            language: "English",
            imageUrl: nil
        )
        
        self.cardInfo = mockCardInfo
        delegate?.cardIdentificationCompleted(card: mockCardInfo)
        
        // Load pricing data
        loadPricingData(cardId: mockCardInfo.id)
    }
    
    private func loadPricingData(cardId: String) {
        isLoading = true
        
        Task {
            do {
                let pricingData = try await cardRepository.getPricing(cardId: cardId)
                
                await MainActor.run {
                    self.pricingData = pricingData
                    self.isLoading = false
                    self.delegate?.pricingDataLoaded(pricing: pricingData)
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.showError(error.localizedDescription)
                    self.delegate?.errorOccurred(error: error)
                    self.analyticsManager.logError(error)
                }
            }
        }
    }
    
    func formatPrice(_ price: Double?, currency: String) -> String {
        guard let price = price else { return "N/A" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        
        return formatter.string(from: NSNumber(value: price)) ?? "N/A"
    }
    
    func shareCard() -> [Any]? {
        guard let cardInfo = cardInfo, let pricingData = pricingData else {
            return nil
        }
        
        let cardName = cardInfo.name
        let brlPrice = formatPrice(pricingData.brlPrice?.avgPrice, currency: "BRL")
        let usdPrice = formatPrice(pricingData.usdPrice?.marketPrice, currency: "USD")
        
        let shareText = "\(cardName)\n💰 BRL: \(brlPrice)\n💵 USD: \(usdPrice)\n\nScanned with PokePrice"
        
        return [shareText]
    }
    
    func saveToHistory() {
        guard let cardInfo = cardInfo, let pricingData = pricingData else {
            return
        }
        
        let imageData = capturedImage.jpegData(compressionQuality: 0.7)
        
        let historyItem = HistoryItem(
            historyId: UUID().uuidString,
            cardId: cardInfo.id,
            cardName: cardInfo.name,
            setName: cardInfo.setName,
            setImageUrl: cardInfo.imageUrl,
            brlPrice: pricingData.brlPrice?.avgPrice,
            usdPrice: pricingData.usdPrice?.marketPrice,
            eurPrice: pricingData.eurPrice?.trendPrice,
            scanDate: Date(),
            imageData: imageData
        )
        
        Task {
            do {
                try await coreDataRepository.saveToHistory(historyItem)
                analyticsManager.logCardScanSuccess(cardId: cardInfo.id, cardName: cardInfo.name)
            } catch {
                analyticsManager.logError(error)
                showError("Failed to save to history: \(error.localizedDescription)")
            }
        }
    }
}