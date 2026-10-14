//
//  ResultsView.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import UIKit

class ResultsView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var setInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    lazy var pricingContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    lazy var brlPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.textColor = .systemGreen
        return label
    }()
    
    lazy var brlPriceSourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var expandableDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show More Prices", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(expandableDetailsTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var expandableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8.0
        view.isHidden = true
        return view
    }()
    
    lazy var usdPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var eurPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Share", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save to History", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var scanAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Scan Another Card", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(scanAgainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onExpandableDetailsTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    var onSaveTapped: (() -> Void)?
    var onScanAgainTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(cardImageView)
        contentView.addSubview(cardNameLabel)
        contentView.addSubview(setInfoLabel)
        contentView.addSubview(pricingContainerView)
        
        pricingContainerView.addSubview(brlPriceLabel)
        pricingContainerView.addSubview(brlPriceSourceLabel)
        pricingContainerView.addSubview(expandableDetailsButton)
        pricingContainerView.addSubview(expandableView)
        
        expandableView.addSubview(usdPriceLabel)
        expandableView.addSubview(eurPriceLabel)
        
        contentView.addSubview(shareButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(scanAgainButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Card Image
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            cardImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cardImageView.widthAnchor.constraint(equalToConstant: 200),
            cardImageView.heightAnchor.constraint(equalToConstant: 280),
            
            // Card Name
            cardNameLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 20),
            cardNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Set Info
            setInfoLabel.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor, constant: 8),
            setInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            setInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Pricing Container
            pricingContainerView.topAnchor.constraint(equalTo: setInfoLabel.bottomAnchor, constant: 20),
            pricingContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pricingContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            pricingContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            // BRL Price
            brlPriceLabel.topAnchor.constraint(equalTo: pricingContainerView.topAnchor, constant: 20),
            brlPriceLabel.centerXAnchor.constraint(equalTo: pricingContainerView.centerXAnchor),
            
            // BRL Source
            brlPriceSourceLabel.topAnchor.constraint(equalTo: brlPriceLabel.bottomAnchor, constant: 4),
            brlPriceSourceLabel.centerXAnchor.constraint(equalTo: pricingContainerView.centerXAnchor),
            
            // Expandable Button
            expandableDetailsButton.topAnchor.constraint(equalTo: brlPriceSourceLabel.bottomAnchor, constant: 16),
            expandableDetailsButton.centerXAnchor.constraint(equalTo: pricingContainerView.centerXAnchor),
            
            // Expandable View
            expandableView.topAnchor.constraint(equalTo: expandableDetailsButton.bottomAnchor, constant: 8),
            expandableView.leadingAnchor.constraint(equalTo: pricingContainerView.leadingAnchor, constant: 16),
            expandableView.trailingAnchor.constraint(equalTo: pricingContainerView.trailingAnchor, constant: -16),
            expandableView.bottomAnchor.constraint(equalTo: pricingContainerView.bottomAnchor, constant: -16),
            
            // USD Price
            usdPriceLabel.topAnchor.constraint(equalTo: expandableView.topAnchor, constant: 12),
            usdPriceLabel.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 12),
            usdPriceLabel.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -12),
            
            // EUR Price
            eurPriceLabel.topAnchor.constraint(equalTo: usdPriceLabel.bottomAnchor, constant: 8),
            eurPriceLabel.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 12),
            eurPriceLabel.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -12),
            eurPriceLabel.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor, constant: -12),
            
            // Buttons
            shareButton.topAnchor.constraint(equalTo: pricingContainerView.bottomAnchor, constant: 20),
            shareButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 12),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            scanAgainButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            scanAgainButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scanAgainButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            scanAgainButton.heightAnchor.constraint(equalToConstant: 50),
            scanAgainButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with cardInfo: CardInfo, pricingData: PricingData, capturedImage: UIImage) {
        cardImageView.image = capturedImage
        cardNameLabel.text = cardInfo.name
        setInfoLabel.text = "\(cardInfo.setName) • \(cardInfo.cardNumber) • \(cardInfo.rarity)"
        
        // BRL Price (Primary)
        if let brlPrice = pricingData.brlPrice?.avgPrice {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "BRL"
            brlPriceLabel.text = formatter.string(from: NSNumber(value: brlPrice))
        } else {
            brlPriceLabel.text = "Price unavailable"
        }
        
        brlPriceSourceLabel.text = pricingData.brlPrice?.source ?? "LigaPokemon"
        
        // USD Price
        if let usdPrice = pricingData.usdPrice?.marketPrice {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            usdPriceLabel.text = "💵 USD: \(formatter.string(from: NSNumber(value: usdPrice)) ?? "N/A")"
        } else {
            usdPriceLabel.text = "💵 USD: N/A"
        }
        
        // EUR Price
        if let eurPrice = pricingData.eurPrice?.trendPrice {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "EUR"
            eurPriceLabel.text = "💶 EUR: \(formatter.string(from: NSNumber(value: eurPrice)) ?? "N/A")"
        } else {
            eurPriceLabel.text = "💶 EUR: N/A"
        }
    }
    
    func toggleExpandableView() {
        expandableView.isHidden.toggle()
        expandableDetailsButton.setTitle(expandableView.isHidden ? "Show More Prices" : "Hide Prices", for: .normal)
    }
    
    @objc private func expandableDetailsTapped() {
        toggleExpandableView()
        onExpandableDetailsTapped?()
    }
    
    @objc private func shareButtonTapped() {
        onShareTapped?()
    }
    
    @objc private func saveButtonTapped() {
        onSaveTapped?()
    }
    
    @objc private func scanAgainButtonTapped() {
        onScanAgainTapped?()
    }
}