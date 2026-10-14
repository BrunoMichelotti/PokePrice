//
//  AnalyticsManagerProtocol.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation

protocol AnalyticsManagerProtocol {
    // MARK: - Event Tracking
    func logCardScanAttempt()
    func logCardScanSuccess(cardId: String, cardName: String)
    func logCardScanFailure(error: Error)
    func logPricingRequest(cardId: String)
    func logCacheHit(cardId: String)
    func logCacheMiss(cardId: String)
    func logManualSearch(query: String)
    func logHistoryView()
    func logHistoryItemDeleted(cardId: String)
    func logSettingsView()
    func logCurrencyPreferenceChanged(currency: String)
    func logCacheCleared()
    func logScreenView(screenName: String)
    func logUserAction(action: String, parameters: [String: Any]?)
    
    // MARK: - Crashlytics
    func logError(_ error: Error)
    func logCustomError(message: String, userInfo: [String: Any]?)
    func setUserID(_ userId: String)
    func setUserProperty(_ value: String?, forName name: String)
    func setCustomKey(_ value: String, forKey key: String)
    func log(message: String)
    func recordNonFatalError(error: Error)
    func setCustomKeysAndValues(_ keysAndValues: [String: Any])
}
