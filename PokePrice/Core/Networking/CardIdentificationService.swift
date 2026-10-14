//
//  CardIdentificationService.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation
import Alamofire

protocol CardIdentificationServiceProtocol {
    func identifyCard(imageData: Data, completion: @escaping (Result<CardIdentificationResponse, APIError>) -> Void)
    func getPricing(cardId: String, completion: @escaping (Result<PricingData, APIError>) -> Void)
}

class CardIdentificationService: CardIdentificationServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://your-backend-url.railway.app" // Replace with your actual deployed backend URL
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func identifyCard(imageData: Data, completion: @escaping (Result<CardIdentificationResponse, APIError>) -> Void) {
        let imageBase64 = imageData.base64EncodedString()
        let url = "\(baseURL)/api/identify"
        let parameters: Parameters = ["image": imageBase64]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(CardIdentificationResponse.self, from: data)
                            completion(.success(result))
                        } catch {
                            completion(.failure(.decodingError(error.localizedDescription)))
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            completion(.failure(.serverError(statusCode: statusCode)))
                        } else {
                            completion(.failure(.networkError(error.localizedDescription)))
                        }
                    }
                }
            }
    }
    
    func getPricing(cardId: String, completion: @escaping (Result<PricingData, APIError>) -> Void) {
        let url = "\(baseURL)/api/pricing/\(cardId)"
        
        AF.request(url, method: .get)
            .validate()
            .responseData { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(PricingData.self, from: data)
                            completion(.success(result))
                        } catch {
                            completion(.failure(.decodingError(error.localizedDescription)))
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            completion(.failure(.serverError(statusCode: statusCode)))
                        } else {
                            completion(.failure(.networkError(error.localizedDescription)))
                        }
                    }
                }
            }
    }
}