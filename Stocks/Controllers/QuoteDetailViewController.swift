//
//  QuoteDetailViewController.swift
//  Stocks
//
//  Created by Anton Tolstov on 08.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit

class QuoteDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var stocks: Stocks!
    var index: Int!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var infoRequestActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var logoUIImage: UIImageView!
    
    @IBOutlet weak var changePercentLabel: UILabel!
    @IBOutlet weak var previousVolumeLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var week52HighLabel: UILabel!
    @IBOutlet weak var week52LowLabel: UILabel!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestQuoteAdditionalInfo()
        requestLogo()
        setDate()
    }
    
    // MARK: - Private methods
    
    private func requestQuoteAdditionalInfo() {
        infoRequestActivityIndicator.startAnimating()
        let oldQuote = stocks.getQuote(for: index, additionalInfo: true) { newQuote in
            DispatchQueue.main.async {
                guard let newQuote = newQuote else {
                    self.infoRequestActivityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Network Error", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                        self.requestQuoteAdditionalInfo()
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.refreshDetails(from: newQuote)
                self.infoRequestActivityIndicator.stopAnimating()
            }
        }
        
        refreshDetails(from: oldQuote!)
    }
    
    private func requestLogo() {
        let logoImage = stocks.getLogo(for: index) { logoImage in
            DispatchQueue.main.async {
                guard self.logoUIImage.image == nil else {
                    return
                }
                
                self.logoUIImage.image = logoImage ?? UIImage(systemName: "questionmark.square")
            }
        }
        
        self.logoUIImage.image = logoImage
    }
    
    private func setDate() {
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        currentDateLabel.text = df.string(from: Date())
    }
    
    private func refreshDetails(from quote: Quote) {
        DispatchQueue.main.async {
            self.companySymbolLabel.text = quote.symbol
            self.companyNameLabel.text = quote.companyName ?? "-"
            
            self.priceLabel.text = quote.latestPrice != nil ? "\(quote.latestPrice!)" : "-"
            
            if let priceChange = quote.change {
                self.priceChangeLabel.text = "\(priceChange)"
                self.priceChangeLabel.textColor = priceChange > 0 ? .green :
                    priceChange < 0 ? .red : .black
            } else {
                self.priceChangeLabel.text = "-"
                self.priceChangeLabel.textColor = .black
            }
            
            self.changePercentLabel.text = quote.changePercent != nil ? "\(quote.changePercent!)" : "-"
            self.previousVolumeLabel.text = quote.previousVolume != nil ? "\(quote.previousVolume!)" : "-"
            self.marketCapLabel.text = quote.marketCap != nil ? "\(quote.marketCap!)" : "-"
            self.week52HighLabel.text = quote.week52High != nil ? "\(quote.week52High!)" : "-"
            self.week52LowLabel.text = quote.week52Low != nil ? "\(quote.week52Low!)" : "-"
        }
    }
}
