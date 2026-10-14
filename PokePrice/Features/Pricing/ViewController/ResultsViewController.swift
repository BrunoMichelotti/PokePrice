//
//  ResultsViewController.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var resultsView: ResultsView?
    let viewModel: ResultsViewModel
    weak var coordinator: ResultsCoordinator?
    
    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.resultsView = ResultsView()
        self.view = self.resultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupResultsViewCallbacks()
        setupNavigation()
        
        // Log screen view
        AnalyticsManager.shared.logScreenView(screenName: "results_screen")
        
        // Start processing the card
        viewModel.processCard()
    }
    
    private func setupViewModel() {
        viewModel.setDelegate(delegate: self)
    }
    
    private func setupResultsViewCallbacks() {
        resultsView?.onExpandableDetailsTapped = {
            AnalyticsManager.shared.logPricingRequest(cardId: self.viewModel.cardInfo?.id ?? "")
        }
        
        resultsView?.onShareTapped = { [weak self] in
            self?.shareCard()
        }
        
        resultsView?.onSaveTapped = { [weak self] in
            self?.saveToHistory()
        }
        
        resultsView?.onScanAgainTapped = { [weak self] in
            self?.scanAgain()
        }
    }
    
    private func setupNavigation() {
        title = "Card Results"
        navigationItem.largeTitleDisplayMode = .never
        
        let backButton = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func shareCard() {
        guard let shareItems = viewModel.shareCard() else {
            showAlert(title: "Error", message: "Unable to share card")
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: shareItems,
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true)
        
        AnalyticsManager.shared.logCardScanAttempt()
    }
    
    private func saveToHistory() {
        viewModel.saveToHistory()
        showAlert(title: "Saved", message: "Card saved to scan history")
        AnalyticsManager.shared.logHistoryView()
    }
    
    private func scanAgain() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ResultsViewController: ResultsViewModelDelegate {
    
    func cardIdentificationCompleted(card: CardInfo) {
        // Update UI when card identification is complete
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let pricingData = self.viewModel.pricingData else { return }
            self.resultsView?.configure(with: card, pricingData: pricingData, capturedImage: self.viewModel.capturedImage)
        }
    }
    
    func pricingDataLoaded(pricing: PricingData) {
        // Update UI when pricing data is loaded
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let cardInfo = self.viewModel.cardInfo else { return }
            self.resultsView?.configure(with: cardInfo, pricingData: pricing, capturedImage: self.viewModel.capturedImage)
        }
    }
    
    func errorOccurred(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "Error", message: error.localizedDescription)
            AnalyticsManager.shared.logError(error)
        }
    }
}