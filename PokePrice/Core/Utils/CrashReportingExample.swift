//
//  CrashReportingExample.swift
//  PokePrice
//
//  Created by Bruno on 28/09/26.
//
//  This file demonstrates how to use Firebase Crashlytics for crash reporting
//  in the PokePrice app. Uncomment and use these examples as needed.

import Foundation
import FirebaseCrashlytics
import UIKit

class CrashReportingExample {
    
    // MARK: - Basic Error Reporting
    
    /// Report a non-fatal error that won't crash the app
    func reportNonFatalError() {
        let error = NSError(domain: "PokePriceError", code: 1001, userInfo: [
            NSLocalizedDescriptionKey: "Failed to process card image"
        ])
        
        AnalyticsManager.shared.recordNonFatalError(error: error)
    }
    
    /// Log a custom error message with additional context
    func reportCustomError() {
        AnalyticsManager.shared.logCustomError(
            message: "Card identification timeout",
            userInfo: [
                "card_id": "charizard_ex_123",
                "timeout_duration": "30s",
                "api_endpoint": "/api/identify"
            ]
        )
    }
    
    // MARK: - Setting User Information
    
    /// Set user ID for crash reporting
    func setUserID(userId: String) {
        AnalyticsManager.shared.setUserID(userId)
    }
    
    /// Set custom user properties
    func setUserProperties() {
        AnalyticsManager.shared.setUserProperty("premium", forName: "subscription_tier")
        AnalyticsManager.shared.setUserProperty("en", forName: "language")
    }
    
    // MARK: - Custom Keys and Values
    
    /// Set custom key-value pairs for crash context
    func setCustomContext() {
        AnalyticsManager.shared.setCustomKeysAndValues([
            "last_scanned_card": "pikachu_base_set",
            "scan_count": "15",
            "preferred_currency": "BRL",
            "app_state": "foreground"
        ])
    }
    
    /// Set individual custom key
    func setSingleCustomKey() {
        AnalyticsManager.shared.setCustomKey("network_type", forKey: "wifi")
    }
    
    // MARK: - Logging
    
    /// Add a log message to crash report
    func addLogMessage() {
        AnalyticsManager.shared.log(message: "User tapped scan button")
        AnalyticsManager.shared.log(message: "Camera permission granted")
        AnalyticsManager.shared.log(message: "Image captured successfully")
    }
    
    // MARK: - Error Handling Examples
    
    /// Example of proper error handling with crash reporting
    func handleNetworkError(error: Error) {
        // Log the error for crash reporting
        AnalyticsManager.shared.logError(error)
        
        // Add context about what happened
        AnalyticsManager.shared.log(message: "Network request failed during card identification")
        
        // Set custom keys for debugging
        AnalyticsManager.shared.setCustomKey("api_endpoint", forKey: "/api/identify")
        AnalyticsManager.shared.setCustomKey("timestamp", forKey: ISO8601DateFormatter().string(from: Date()))
    }
    
    /// Example of handling image processing errors
    func handleImageProcessingError(error: Error, imageData: Data) {
        // Log the error
        AnalyticsManager.shared.recordNonFatalError(error: error)
        
        // Add context
        AnalyticsManager.shared.logCustomError(
            message: "Image processing failed",
            userInfo: [
                "image_size": "\(imageData.count) bytes",
                "error_type": String(describing: type(of: error))
            ]
        )
    }
    
    /// Example of handling database errors
    func handleDatabaseError(error: Error, operation: String) {
        // Log the error with operation context
        AnalyticsManager.shared.logCustomError(
            message: "Database operation failed",
            userInfo: [
                "operation": operation,
                "error_description": error.localizedDescription
            ]
        )
    }
    
    // MARK: - Force Crash (For Testing Only)
    
    /// Force a crash to test Crashlytics setup
    /// WARNING: Only use this for testing in development
    func forceCrash() {
        #if DEBUG
        // Create a crash button programmatically
        let crashButton = UIButton(type: .system)
        crashButton.setTitle("Test Crash", for: .normal)
        crashButton.addTarget(self, action: #selector(crashButtonTapped), for: .touchUpInside)
        // Add crashButton to your view for testing
        #endif
    }
    
    @objc private func crashButtonTapped() {
        #if DEBUG
        fatalError("This is a test crash for Crashlytics")
        #endif
    }
    
    // MARK: - Performance Monitoring Integration
    
    /// Log performance metrics
    func logPerformanceMetrics(operation: String, duration: TimeInterval) {
        AnalyticsManager.shared.logCustomError(
            message: "Performance metric",
            userInfo: [
                "operation": operation,
                "duration": "\(duration)s",
                "threshold": "2.0s"
            ]
        )
    }
    
    /// Log memory warnings
    func logMemoryWarning() {
        AnalyticsManager.shared.log(message: "Memory warning received")
        AnalyticsManager.shared.setCustomKey("memory_warning_count", forKey: "1")
    }
}

// MARK: - Usage Examples

/*
 // Example 1: Report a network error
 func handleCardIdentificationFailure(error: Error) {
     let crashReporter = CrashReportingExample()
     crashReporter.handleNetworkError(error: error)
     
     // Show user-friendly error message to user
 }
 
 // Example 2: Set user information on login
 func onUserLogin(userId: String, email: String) {
     AnalyticsManager.shared.setUserID(userId)
     AnalyticsManager.shared.setUserProperty(email, forName: "user_email")
 }
 
 // Example 3: Add context before critical operations
 func beforeCardScan() {
     AnalyticsManager.shared.log(message: "Starting card scan")
     AnalyticsManager.shared.setCustomKey("scan_start_time", forKey: Date().description)
 }
 
 // Example 4: Report non-fatal errors
 func onImageProcessingFailure(error: Error, imageData: Data) {
     let crashReporter = CrashReportingExample()
     crashReporter.handleImageProcessingError(error: error, imageData: imageData)
 }
 
 // Example 5: Log app lifecycle events
 func onAppLaunch() {
     AnalyticsManager.shared.log(message: "App launched successfully")
     AnalyticsManager.shared.setCustomKey("launch_timestamp", forKey: Date().description)
 }
 */