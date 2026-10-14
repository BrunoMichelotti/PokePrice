//
//  PokeBallIconView.swift
//  PokePrice
//
//  Created by Bruno on 28/09/26.
//

import UIKit

class PokeBallIconView: UIView {
    
    private let topHalfLayer = CAShapeLayer()
    private let bottomHalfLayer = CAShapeLayer()
    private let centerLineLayer = CAShapeLayer()
    private let centerButtonLayer = CAShapeLayer()
    private let centerButtonBorderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        setupLayers()
    }
    
    private func setupLayers() {
        layer.addSublayer(topHalfLayer)
        layer.addSublayer(bottomHalfLayer)
        layer.addSublayer(centerLineLayer)
        layer.addSublayer(centerButtonLayer)
        layer.addSublayer(centerButtonBorderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    private func updateLayers() {
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        let radius = min(bounds.width, bounds.height) / 2 - 10
        
        // Top half (red)
        let topPath = UIBezierPath()
        topPath.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: .pi, endAngle: 0, clockwise: true)
        topPath.addLine(to: CGPoint(x: centerX, y: centerY))
        topPath.close()
        
        topHalfLayer.path = topPath.cgPath
        topHalfLayer.fillColor = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
        
        // Bottom half (white)
        let bottomPath = UIBezierPath()
        bottomPath.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi, clockwise: true)
        bottomPath.addLine(to: CGPoint(x: centerX, y: centerY))
        bottomPath.close()
        
        bottomHalfLayer.path = bottomPath.cgPath
        bottomHalfLayer.fillColor = UIColor.white.cgColor
        
        // Center line
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: centerX - radius, y: centerY))
        linePath.addLine(to: CGPoint(x: centerX + radius, y: centerY))
        
        centerLineLayer.path = linePath.cgPath
        centerLineLayer.strokeColor = UIColor.black.cgColor
        centerLineLayer.lineWidth = 4
        
        // Center button
        let buttonRadius = radius * 0.25
        let buttonPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: buttonRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        centerButtonLayer.path = buttonPath.cgPath
        centerButtonLayer.fillColor = UIColor.white.cgColor
        
        centerButtonBorderLayer.path = buttonPath.cgPath
        centerButtonBorderLayer.fillColor = UIColor.clear.cgColor
        centerButtonBorderLayer.strokeColor = UIColor.black.cgColor
        centerButtonBorderLayer.lineWidth = 3
    }
}