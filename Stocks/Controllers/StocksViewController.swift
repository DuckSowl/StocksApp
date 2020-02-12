//
//  StocksViewController.swift
//  Stocks
//
//  Created by Anton Tolstov on 08.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit

class StocksViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var quotesTable: UITableView!
    
    // MARK: - Properties
    
    private let stocks = Stocks()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSegue(withIdentifier: "ShowLoadingScreen", sender: nil)
        
        quotesTable.delegate = self
        quotesTable.dataSource = self
        
        setDate()
        
        requestQuotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        quotesTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
            let quoteDetail = segue.destination as? QuoteDetailViewController,
            let indexPath = quotesTable.indexPathForSelectedRow {
            quoteDetail.stocks = stocks
            quoteDetail.index = indexPath.row
        }
    }
    
    // MARK: - Private methods
    
    private func setDate() {
        let df = DateFormatter()
        df.dateFormat = "MMMM d"
        currentDateLabel.text = df.string(from: Date())
    }
    
    private func requestQuotes() {
        stocks.loadSymbols(with: 10) { res in
            DispatchQueue.main.async {
                switch res {
                case .failure:
                    self.showAlert(with: "Network Error", retry: self.requestQuotes)
                case .success:
                    self.quotesTable.reloadData()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func showAlert(with message: String = "", retry: @escaping ()->()) {
        let alertController = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            retry()
        })
        
        navigationController?.topViewController?.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension StocksViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! QuoteCell
        
        cell.quote = stocks.getQuote(for: indexPath.row) { quote in
            DispatchQueue.main.async {
                guard let quote = quote,
                    let cell = self.quotesTable.cellForRow(at: indexPath) as? QuoteCell
                    else { return }
                
                cell.quote = quote
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
