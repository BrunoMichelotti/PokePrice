//
//  BaseViewModel.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var cancellables = Set<AnyCancellable>()
    
    func showError(_ message: String) {
        self.errorMessage = message
    }
    
    func clearError() {
        self.errorMessage = nil
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// For classes that need to inherit from NSObject
class NSObjectViewModel: NSObject {
    var isLoading: Bool = false
    var errorMessage: String?
    
    var cancellables = Set<AnyCancellable>()
    
    func showError(_ message: String) {
        self.errorMessage = message
    }
    
    func clearError() {
        self.errorMessage = nil
    }
    
    deinit {
        cancellables.removeAll()
    }
}
