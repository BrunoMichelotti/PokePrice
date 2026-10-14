//
//  WelcomeViewModel.swift
//  PokePrice
//
//  Created by Bruno on 28/09/26.
//

import Foundation

protocol WelcomeViewModelDelegate: AnyObject {
    func navigateToCamera()
}

class WelcomeViewModel {
    
    weak var delegate: WelcomeViewModelDelegate?
    
    func setDelegate(delegate: WelcomeViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func startScanning() {
        delegate?.navigateToCamera()
    }
}