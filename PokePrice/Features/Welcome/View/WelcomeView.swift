//
//  WelcomeView.swift
//  PokePrice
//
//  Created by Bruno on 28/09/26.
//

import UIKit

class WelcomeView: UIView {
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.15, green: 0.05, blue: 0.25, alpha: 1.0) // Dark purple
        return view
    }()
    
    lazy var pokeballIconView: PokeBallIconView = {
        let view = PokeBallIconView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Descubra o valor da sua carta"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Escaneie qualquer carta Pokémon TCG e veja o preço de mercado em tempo real"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Escanear Carta", for: .normal)
        button.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0) // Orange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .white
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        button.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var dotsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var onScanTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(backgroundView)
        backgroundView.addSubview(pokeballIconView)
        backgroundView.addSubview(dotsContainerView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(subtitleLabel)
        backgroundView.addSubview(scanButton)
        
        setupGlowingDots()
        setupConstraints()
    }
    
    private func setupGlowingDots() {
        // Create multiple glowing dots around the Poké Ball
        let dotPositions: [(CGFloat, CGFloat)] = [
            (0.3, 0.2), (0.7, 0.2), (0.2, 0.4), (0.8, 0.4),
            (0.15, 0.6), (0.85, 0.6), (0.25, 0.8), (0.75, 0.8)
        ]
        
        for (xPercent, yPercent) in dotPositions {
            let dot = createGlowingDot()
            dotsContainerView.addSubview(dot)
            
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.centerXAnchor.constraint(equalTo: dotsContainerView.centerXAnchor, constant: 0).isActive = true
            dot.centerYAnchor.constraint(equalTo: dotsContainerView.centerYAnchor, constant: 0).isActive = true
            dot.transform = CGAffineTransform(translationX: xPercent * 300 - 150, y: yPercent * 400 - 200)
        }
    }
    
    private func createGlowingDot() -> UIView {
        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // Yellow
        dot.layer.cornerRadius = 4.0
        dot.layer.shadowColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0).cgColor
        dot.layer.shadowOffset = CGSize(width: 0, height: 0)
        dot.layer.shadowRadius = 8.0
        dot.layer.shadowOpacity = 0.8
        dot.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        return dot
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Dots container - centered behind Poké Ball
            dotsContainerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            dotsContainerView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -50),
            dotsContainerView.widthAnchor.constraint(equalToConstant: 300),
            dotsContainerView.heightAnchor.constraint(equalToConstant: 400),
            
            // Poké Ball icon - centered
            pokeballIconView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            pokeballIconView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -80),
            pokeballIconView.widthAnchor.constraint(equalToConstant: 200),
            pokeballIconView.heightAnchor.constraint(equalToConstant: 200),
            
            // Title label - below Poké Ball
            titleLabel.topAnchor.constraint(equalTo: pokeballIconView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -32),
            
            // Subtitle label - below title
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -32),
            
            // Scan button - bottom
            scanButton.bottomAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            scanButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 32),
            scanButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -32),
            scanButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func scanButtonTapped() {
        onScanTapped?()
    }
}