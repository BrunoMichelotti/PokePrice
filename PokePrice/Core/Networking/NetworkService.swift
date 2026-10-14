//
//  NetworkService.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private let baseURL = "https://your-backend-url.railway.app" // Replace with your actual deployed backend URL
    
    private init() {}
    
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL + endpoint.path
        
        AF.request(url, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding, headers: endpoint.headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    }
}

enum Endpoint: Sendable {
    case identifyCard(imageBase64: String)
    case getPricing(cardId: String)
    case currencyConversion(from: String, to: String)
    
    var path: String {
        switch self {
        case .identifyCard:
            return "/api/identify"
        case .getPricing(let cardId):
            return "/api/pricing/\(cardId)"
        case .currencyConversion:
            return "/api/currency/convert"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .identifyCard:
            return .post
        case .getPricing:
            return .get
        case .currencyConversion:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .identifyCard(let imageBase64):
            return ["image": imageBase64]
        case .getPricing:
            return nil
        case .currencyConversion(let from, let to):
            return ["from": from, "to": to]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .identifyCard:
            return JSONEncoding.default
        case .getPricing, .currencyConversion:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders? {
        var headers = HTTPHeaders()
        headers.add(.contentType("application/json"))
        // Additional headers like authentication can be added here
        return headers
    }
}