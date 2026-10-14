//
//  CameraView.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    lazy var cardOutlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.systemYellow.cgColor
        view.layer.borderWidth = 3.0
        view.layer.cornerRadius = 12.0
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.1)
        return view
    }()
    
    lazy var guidanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Position the card within the frame"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.layer.cornerRadius = 8.0
        label.clipsToBounds = true
        return label
    }()
    
    lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 35.0
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var switchCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.cornerRadius = 25.0
        button.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var flashButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bolt.slash"), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.cornerRadius = 25.0
        button.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var manualSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Manual Search", for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(manualSearchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onCaptureTapped: (() -> Void)?
    var onSwitchCameraTapped: (() -> Void)?
    var onFlashTapped: (() -> Void)?
    var onManualSearchTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .black
        addSubview(cardOutlineView)
        addSubview(guidanceLabel)
        addSubview(captureButton)
        addSubview(switchCameraButton)
        addSubview(flashButton)
        addSubview(manualSearchButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Card outline - centered with typical card aspect ratio
            cardOutlineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardOutlineView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardOutlineView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            cardOutlineView.heightAnchor.constraint(equalTo: cardOutlineView.widthAnchor, multiplier: 1.4),
            
            // Guidance label - above card outline
            guidanceLabel.topAnchor.constraint(equalTo: cardOutlineView.bottomAnchor, constant: 20),
            guidanceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            guidanceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            guidanceLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            guidanceLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Capture button - bottom center
            captureButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            captureButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Switch camera button - bottom right
            switchCameraButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            switchCameraButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            switchCameraButton.widthAnchor.constraint(equalToConstant: 50),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Flash button - bottom left
            flashButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            flashButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            flashButton.widthAnchor.constraint(equalToConstant: 50),
            flashButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Manual search button - top right
            manualSearchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            manualSearchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            manualSearchButton.widthAnchor.constraint(equalToConstant: 120),
            manualSearchButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func setupPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        layer.frame = bounds
        layer.videoGravity = .resizeAspectFill
        self.previewLayer = layer
        layer.insertSublayer(layer, at: 0)
    }
    
    @objc private func captureButtonTapped() {
        onCaptureTapped?()
    }
    
    @objc private func switchCameraButtonTapped() {
        onSwitchCameraTapped?()
    }
    
    @objc private func flashButtonTapped() {
        onFlashTapped?()
    }
    
    @objc private func manualSearchButtonTapped() {
        onManualSearchTapped?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}