//
//  NetworkService.swift
//  PokePrice
//
//  Created by Bruno on 03/11/26.
//

import Foundation

class NetworkService {

    static let shared = NetworkService()

    private let baseURL: String
    private let session: URLSession

    private init() {
        self.baseURL = "https://pokeprice-production-b0ac.up.railway.app"
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: configuration)
    }

    // MARK: - Health Check

    func healthCheck() async throws -> HealthResponse {
        let endpoint = "/health"
        return try await performRequest(endpoint: endpoint, method: .get)
    }

    // MARK: - Card Identification

    func identifyCard(image: Data) async throws -> CardIdentificationResponse {
        let endpoint = "/api/identify"
        let base64Image = image.base64EncodedString()
        let requestBody = CardIdentificationRequest(image: base64Image)
        return try await performRequest(endpoint: endpoint, method: .post, body: requestBody)
    }

    // MARK: - Pricing

    func getPricing(cardId: String) async throws -> PricingData {
        let endpoint = "/api/pricing/\(cardId)"
        return try await performRequest(endpoint: endpoint, method: .get)
    }

    // MARK: - Currency Conversion

    func convertCurrency(from: String, to: String, amount: Double) async throws -> CurrencyConversionResponse {
        let endpoint = "/api/currency/convert"
        let requestBody = CurrencyConversionRequest(fromCurrency: from, toCurrency: to, amount: amount)
        return try await performRequest(endpoint: endpoint, method: .post, body: requestBody)
    }

    // MARK: - Generic Request

    private func performRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - Network Error

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case encodingError(Error)
    case networkUnavailable

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .networkUnavailable:
            return "Network is unavailable"
        }
    }
}
