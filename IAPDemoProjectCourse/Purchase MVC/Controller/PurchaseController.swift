//
//  PurchaseController.swift
//  IAPDemoProjectCourse
//
//  Created by mac on 08.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let iapManager = IAPManager.shared
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(IAPManager.productNotificationIdentifire), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func restorePurchases() {
        print("restoring purchases")
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchases))
    }
    
    private func priceStringFor(product: SKProduct) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency // Валюта
        numberFormatter.locale = product.priceLocale // Тип валюты
        
        return numberFormatter.string(from: product.price)!
    }
    
    @objc private func reload() {
        self.tableView.reloadData()
    }
}

extension PurchaseController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return iapManager.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.purchaseCell, for: indexPath)
        
        let product = iapManager.products[indexPath.row]
        cell.textLabel?.text = product.localizedTitle + " - "  + self.priceStringFor(product: product)
        return cell
    }
}


extension PurchaseController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let identifier = iapManager.products[indexPath.row].productIdentifier
        iapManager.purchase(productWith: identifier)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}








