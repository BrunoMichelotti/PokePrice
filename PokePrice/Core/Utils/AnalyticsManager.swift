//
//  AnalyticsManager.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics

class AnalyticsManager: AnalyticsManagerProtocol {
    
    static let shared = AnalyticsManager()
    
    private init() {}
    
    // MARK: - Event Tracking
    
    func logCardScanAttempt() {
        Analytics.logEvent("card_scan_attempt", parameters: nil)
    }
    
    func logCardScanSuccess(cardId: String, cardName: String) {
        Analytics.logEvent("card_scan_success", parameters: [
            "card_id": cardId,
            "card_name": cardName
        ])
    }
    
    func logCardScanFailure(error: Error) {
        Analytics.logEvent("card_scan_failure", parameters: [
            "error": error.localizedDescription
        ])
    }
    
    func logPricingRequest(cardId: String) {
        Analytics.logEvent("pricing_request", parameters: [
            "card_id": cardId
        ])
    }
    
    func logCacheHit(cardId: String) {
        Analytics.logEvent("cache_hit", parameters: [
            "card_id": cardId
        ])
    }
    
    func logCacheMiss(cardId: String) {
        Analytics.logEvent("cache_miss", parameters: [
            "card_id": cardId
        ])
    }
    
    func logManualSearch(query: String) {
        Analytics.logEvent("manual_search", parameters: [
            "query": query
        ])
    }
    
    func logHistoryView() {
        Analytics.logEvent("history_view", parameters: nil)
    }
    
    func logHistoryItemDeleted(cardId: String) {
        Analytics.logEvent("history_item_deleted", parameters: [
            "card_id": cardId
        ])
    }
    
    func logSettingsView() {
        Analytics.logEvent("settings_view", parameters: nil)
    }
    
    func logCurrencyPreferenceChanged(currency: String) {
        Analytics.logEvent("currency_preference_changed", parameters: [
            "currency": currency
        ])
    }
    
    func logCacheCleared() {
        Analytics.logEvent("cache_cleared", parameters: nil)
    }
    
    func logScreenView(screenName: String) {
        Analytics.logEvent("screen_view", parameters: [
            "screen_name": screenName
        ])
    }
    
    func logUserAction(action: String, parameters: [String: Any]? = nil) {
        var eventParams: [String: Any] = ["action": action]
        if let parameters = parameters {
            eventParams.merge(parameters) { _, new in new }
        }
        Analytics.logEvent("user_action", parameters: eventParams)
    }
    
    // MARK: - Crashlytics
    
    func logError(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    func logCustomError(message: String, userInfo: [String: Any]? = nil) {
        Crashlytics.crashlytics().log(message)
        if let userInfo = userInfo {
            Crashlytics.crashlytics().setCustomValue(userInfo, forKey: "error_context")
        }
    }
    
    func setUserID(_ userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
        Analytics.setUserID(userId)
    }
    
    func setUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    // MARK: - Additional Crashlytics Methods
    
    func setCustomKey(_ value: String, forKey key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    func log(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    func recordNonFatalError(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    func setCustomKeysAndValues(_ keysAndValues: [String: Any]) {
        for (key, value) in keysAndValues {
            Crashlytics.crashlytics().setCustomValue(value, forKey: key)
        }
    }
}