//
//  CameraViewController.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var cameraView: CameraView?
    let viewModel: CameraViewModel = CameraViewModel()
    let cardIdentificationService: CardIdentificationServiceProtocol = CardIdentificationService()
    weak var coordinator: CameraCoordinator?
    
    override func loadView() {
        self.cameraView = CameraView()
        self.view = self.cameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupCameraViewCallbacks()
        setupNavigation()
        
        // Log screen view
        AnalyticsManager.shared.logScreenView(screenName: "camera_screen")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCameraPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopSession()
    }
    
    private func setupViewModel() {
        viewModel.setDelegate(delegate: self)
    }
    
    private func setupCameraViewCallbacks() {
        cameraView?.onCaptureTapped = { [weak self] in
            self?.viewModel.capturePhoto()
        }
        
        cameraView?.onSwitchCameraTapped = { [weak self] in
            self?.viewModel.switchCamera()
        }
        
        cameraView?.onFlashTapped = { [weak self] in
            self?.toggleFlash()
        }
        
        cameraView?.onManualSearchTapped = { [weak self] in
            self?.showManualSearch()
        }
    }
    
    private func setupNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            setupCamera()
        case .notDetermined:
            viewModel.requestCameraPermission()
        case .denied, .restricted:
            showCameraPermissionAlert()
        @unknown default:
            showCameraPermissionAlert()
        }
    }
    
    private func setupCamera() {
        viewModel.setupCamera()
        
        if let previewLayer = viewModel.getPreviewLayer() {
            cameraView?.setupPreviewLayer(previewLayer)
        }
        
        viewModel.startSession()
    }
    
    private func toggleFlash() {
        guard let device = viewModel.videoDevice else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if device.torchMode == .on {
                    device.torchMode = .off
                    cameraView?.flashButton.setImage(UIImage(systemName: "bolt.slash"), for: .normal)
                } else {
                    try device.setTorchModeOn(level: 1.0)
                    cameraView?.flashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
                }
                device.unlockForConfiguration()
            } catch {
                print("Error toggling flash: \(error)")
            }
        }
    }
    
    private func showManualSearch() {
        let alert = UIAlertController(title: "Manual Search", message: "Enter card name or set code", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "e.g., Charizard ex"
        }
        
        alert.addAction(UIAlertAction(title: "Search", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, let query = textField.text, !query.isEmpty else {
                return
            }
            self?.performManualSearch(query: query)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func performManualSearch(query: String) {
        // TODO: Implement manual search functionality
        // This would call the backend with a text search instead of image analysis
        AnalyticsManager.shared.logManualSearch(query: query)
        print("Manual search for: \(query)")
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Required",
            message: "PokePrice needs camera access to scan Pokemon TCG cards. Please enable camera access in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func processCapturedImage(_ image: UIImage) {
        guard let compressedImageData = image.jpegData(compressionQuality: 0.7) else {
            showError(CameraError.configurationFailed)
            return
        }
        
        viewModel.delegate?.processingStateChanged(state: .uploading)
        
        // Upload to backend and process
        uploadImageToBackend(imageData: compressedImageData)
    }
    
    private func uploadImageToBackend(imageData: Data) {
        cardIdentificationService.identifyCard(imageData: imageData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if response.success, let cardInfo = response.card {
                    self.viewModel.delegate?.processingStateChanged(state: .analyzing)
                    
                    // Convert card info dict to CardInfo model
                    if let cardDict = cardInfo as? [String: Any],
                       let cardInfoModel = self.parseCardInfo(cardDict),
                       let capturedImage = UIImage(data: imageData) {
                        self.showResultsScreen(with: capturedImage, cardInfo: cardInfoModel)
                    } else if let capturedImage = UIImage(data: imageData) {
                        self.showResultsScreen(with: capturedImage)
                    }
                } else {
                    self.viewModel.delegate?.processingStateChanged(state: .failed(APIError.customError(response.error ?? "Identification failed")))
                    self.showError(APIError.customError(response.error ?? "Identification failed"))
                }
            case .failure(let error):
                self.viewModel.delegate?.processingStateChanged(state: .failed(error))
                self.showError(error)
            }
        }
    }
    
    private func parseCardInfo(_ dict: [String: Any]) -> CardInfo? {
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String,
              let setName = dict["setName"] as? String,
              let setCode = dict["setCode"] as? String,
              let cardNumber = dict["cardNumber"] as? String,
              let rarity = dict["rarity"] as? String else {
            return nil
        }
        
        return CardInfo(
            id: id,
            name: name,
            setName: setName,
            setCode: setCode,
            cardNumber: cardNumber,
            rarity: rarity,
            condition: dict["condition"] as? String,
            language: dict["language"] as? String,
            imageUrl: dict["imageUrl"] as? String
        )
    }
    
    private func showResultsScreen(with image: UIImage, cardInfo: CardInfo? = nil) {
        coordinator?.showResults(with: image, cardInfo: cardInfo)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
        
        AnalyticsManager.shared.logError(error)
    }
}

extension CameraViewController: CameraViewModelDelegate {
    
    func cameraPermissionGranted() {
        setupCamera()
    }
    
    func cameraPermissionDenied() {
        showCameraPermissionAlert()
    }
    
    func cameraConfigurationFailed(error: Error) {
        showError(error)
    }
    
    func imageCaptured(image: UIImage) {
        processCapturedImage(image)
    }
    
    func processingStateChanged(state: ProcessingState) {
        switch state {
        case .idle:
            cameraView?.guidanceLabel.text = "Position the card within the frame"
        case .capturing:
            cameraView?.guidanceLabel.text = "Capturing..."
        case .uploading:
            cameraView?.guidanceLabel.text = "Uploading..."
        case .analyzing:
            cameraView?.guidanceLabel.text = "Analyzing card..."
        case .completed:
            cameraView?.guidanceLabel.text = "Position the card within the frame"
        case .failed(let error):
            cameraView?.guidanceLabel.text = "Error: \(error.localizedDescription)"
        }
    }
}