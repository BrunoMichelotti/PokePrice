//
//  CameraViewModel.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation
import AVFoundation
import UIKit
import Combine

protocol CameraViewModelDelegate: AnyObject {
    func cameraPermissionGranted()
    func cameraPermissionDenied()
    func cameraConfigurationFailed(error: Error)
    func imageCaptured(image: UIImage)
    func processingStateChanged(state: ProcessingState)
}

enum ProcessingState {
    case idle
    case capturing
    case uploading
    case analyzing
    case completed
    case failed(Error)
}

class CameraViewModel: NSObjectViewModel {
    
    weak var delegate: CameraViewModelDelegate?
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput: AVCapturePhotoOutput?
    var videoDevice: AVCaptureDevice?
    
    // Camera configuration
    private let sessionQueue = DispatchQueue(label: "com.pokeprice.camera.session")
    
    override init() {
        super.init()
    }
    
    func setDelegate(delegate: CameraViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.delegate?.cameraPermissionGranted()
                } else {
                    self?.delegate?.cameraPermissionDenied()
                }
            }
        }
    }
    
    func setupCamera() {
        sessionQueue.async { [weak self] in
            self?.configureCaptureSession()
        }
    }
    
    private func configureCaptureSession() {
        let session = AVCaptureSession()
        
        // Configure session for high quality photo capture
        session.sessionPreset = .photo
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            DispatchQueue.main.async {
                self.delegate?.cameraConfigurationFailed(error: CameraError.noCameraAvailable)
            }
            return
        }
        
        self.videoDevice = videoDevice
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            } else {
                DispatchQueue.main.async {
                    self.delegate?.cameraConfigurationFailed(error: CameraError.inputAddFailed)
                }
                return
            }
            
            // Configure photo output
            let photoOutput = AVCapturePhotoOutput()
            photoOutput.isHighResolutionCaptureEnabled = true
            
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
                self.photoOutput = photoOutput
            } else {
                DispatchQueue.main.async {
                    self.delegate?.cameraConfigurationFailed(error: CameraError.outputAddFailed)
                }
                return
            }
            
            self.captureSession = session
            
            DispatchQueue.main.async {
                self.delegate?.cameraPermissionGranted()
            }
            
        } catch {
            DispatchQueue.main.async {
                self.delegate?.cameraConfigurationFailed(error: error)
            }
        }
    }
    
    func startSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession?.stopRunning()
        }
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        guard let captureSession = captureSession else { return nil }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer
        return previewLayer
    }
    
    func capturePhoto() {
        guard let photoOutput = photoOutput else { return }
        
        DispatchQueue.main.async {
            self.delegate?.processingStateChanged(state: .capturing)
        }
        
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        settings.flashMode = .auto
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func switchCamera() {
        guard let currentSession = captureSession else { return }
        
        sessionQueue.async {
            currentSession.beginConfiguration()
            
            guard let currentInput = currentSession.inputs.first as? AVCaptureDeviceInput else {
                currentSession.commitConfiguration()
                return
            }
            
            let newPosition: AVCaptureDevice.Position = currentInput.device.position == .back ? .front : .back
            
            guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else {
                currentSession.commitConfiguration()
                return
            }
            
            do {
                let newInput = try AVCaptureDeviceInput(device: newDevice)
                currentSession.removeInput(currentInput)
                
                if currentSession.canAddInput(newInput) {
                    currentSession.addInput(newInput)
                    self.videoDevice = newDevice
                } else {
                    currentSession.addInput(currentInput)
                }
                
                currentSession.commitConfiguration()
            } catch {
                currentSession.commitConfiguration()
            }
        }
    }
    
    private func compressImage(_ image: UIImage) -> Data? {
        // Moderate compression: balance between quality and size
        let compressionQuality: CGFloat = 0.7
        return image.jpegData(compressionQuality: compressionQuality)
    }
}

enum CameraError: Error {
    case noCameraAvailable
    case inputAddFailed
    case outputAddFailed
    case permissionDenied
    case configurationFailed
    
    var localizedDescription: String {
        switch self {
        case .noCameraAvailable:
            return "No camera available on this device"
        case .inputAddFailed:
            return "Failed to add camera input"
        case .outputAddFailed:
            return "Failed to add camera output"
        case .permissionDenied:
            return "Camera permission was denied"
        case .configurationFailed:
            return "Camera configuration failed"
        }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            DispatchQueue.main.async {
                self.delegate?.processingStateChanged(state: .failed(error))
            }
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            DispatchQueue.main.async {
                self.delegate?.processingStateChanged(state: .failed(CameraError.configurationFailed))
            }
            return
        }
        
        DispatchQueue.main.async {
            self.delegate?.imageCaptured(image: image)
        }
    }
}