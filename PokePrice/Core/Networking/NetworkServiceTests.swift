//
//  NetworkServiceTests.swift
//  PokePrice
//
//  Created by Bruno on 03/11/26.
//

import Foundation

// Simple test class to verify NetworkService works
// This can be called from a ViewController or test suite

class NetworkServiceTests {

    static func testHealthCheck() async {
        do {
            let networkService = NetworkService.shared
            let response = try await networkService.healthCheck()
            print("✅ Health check successful: \(response.status)")
        } catch {
            print("❌ Health check failed: \(error.localizedDescription)")
        }
    }

    static func testPricing() async {
        do {
            let networkService = NetworkService.shared
            let pricing = try await networkService.getPricing(cardId: "charizard_ex_123")
            print("✅ Pricing fetched successfully")
            print("BRL Price: \(pricing.brlPrice?.avgPrice ?? 0)")
        } catch {
            print("❌ Pricing fetch failed: \(error.localizedDescription)")
        }
    }

    static func testCurrencyConversion() async {
        do {
            let networkService = NetworkService.shared
            let response = try await networkService.convertCurrency(from: "USD", to: "BRL", amount: 45.0)
            print("✅ Currency conversion successful: \(response.result ?? 0)")
        } catch {
            print("❌ Currency conversion failed: \(error.localizedDescription)")
        }
    }
}
