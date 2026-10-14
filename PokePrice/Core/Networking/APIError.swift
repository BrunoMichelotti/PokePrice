//
//  APIError.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation

enum APIError: Error, LocalizedError, Sendable {
    case invalidURL
    case networkError(String)
    case serverError(statusCode: Int)
    case decodingError(String)
    case encodingError(String)
    case noData
    case customError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let message):
            return "Network error: \(message)"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .encodingError(let message):
            return "Encoding error: \(message)"
        case .noData:
            return "No data received"
        case .customError(let message):
            return message
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again."
        case .serverError:
            return "Server is temporarily unavailable. Please try again later."
        case .decodingError, .encodingError:
            return "There was a data processing error. Please try again."
        default:
            return "Please try again or contact support if the problem persists."
        }
    }
}