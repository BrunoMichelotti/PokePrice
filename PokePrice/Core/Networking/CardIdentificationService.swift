//
//  CardIdentificationService.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation

protocol CardIdentificationServiceProtocol {
    func identifyCard(imageData: Data, completion: @escaping (Result<CardIdentificationResponse, APIError>) -> Void)
    func getPricing(cardId: String, completion: @escaping (Result<PricingData, APIError>) -> Void)
}

class CardIdentificationService: CardIdentificationServiceProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func identifyCard(imageData: Data, completion: @escaping (Result<CardIdentificationResponse, APIError>) -> Void) {
        Task {
            do {
                let response = try await networkService.identifyCard(image: imageData)
                // Convert backend response to local model
                let localResponse = CardIdentificationResponse(
                    success: response.success,
                    card: response.card,
                    error: response.error
                )
                await MainActor.run {
                    completion(.success(localResponse))
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(.customError(error.localizedDescription)))
                }
            }
        }
    }

    func getPricing(cardId: String, completion: @escaping (Result<PricingData, APIError>) -> Void) {
        Task {
            do {
                let pricing = try await networkService.getPricing(cardId: cardId)
                await MainActor.run {
                    completion(.success(pricing))
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(.customError(error.localizedDescription)))
                }
            }
        }
    }
}