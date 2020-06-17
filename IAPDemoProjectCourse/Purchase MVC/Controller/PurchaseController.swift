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
    let notificationCenter = NotificationCenter.default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        setupNavigationBar()
        
        notificationCenter.addObserver(self, selector: #selector(reload), name: NSNotification.Name(IAPManager.productNotificationIdentifire), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(completeConsumable), name: NSNotification.Name(IAPProducts.consumable.rawValue), object: nil)
        notificationCenter.addObserver(self, selector: #selector(completeNonConsumable), name: NSNotification.Name(IAPProducts.nonConsumable.rawValue), object: nil)
        notificationCenter.addObserver(self, selector: #selector(completeAutorenewable), name: NSNotification.Name(IAPProducts.autorenewable.rawValue), object: nil)
        notificationCenter.addObserver(self, selector: #selector(completeNonRenewing), name: NSNotification.Name(IAPProducts.nonRenewing.rawValue), object: nil)
        
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc private func restorePurchases() {
        iapManager.restoreCompletedTransactions()
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
    
    @objc private func completeConsumable() {
        print("Consumable")
    }
    
    @objc private func completeNonConsumable() {
        print("nonConsumable")
    }
    
    @objc private func completeAutorenewable() {
        print("Autorenewable")
    }
    
    @objc private func completeNonRenewing() {
        print("NonRenewing")
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
