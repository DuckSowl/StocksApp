//
//  QuoteCell.swift
//  Stocks
//
//  Created by Anton Tolstov on 08.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!

    var quote: Quote? {
        didSet {
            updateInfo()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
    func updateInfo() {
        if let quote = quote {
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
        }
    }
    
}
