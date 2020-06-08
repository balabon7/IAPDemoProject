//
//  IAPManager.swift
//  IAPDemoProjectCourse
//
//  Created by mac on 08.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
    
    static let shared = IAPManager()
    
    private override init() { }
    
    var products: [SKProduct] = []
    
    public func setupPurchases(callback: @escaping(Bool) -> ()) {
        // проверка устройства на осущиствление платежа
        if SKPaymentQueue.canMakePayments()  {
            SKPaymentQueue.default().add(self)
            callback(true)
            return
        }
        callback(false)
    }
    
    public func getProducts() {
        let identifiers: Set = [IAPProducts.consumable.rawValue,
                                IAPProducts.nonConsumable.rawValue,
                                IAPProducts.autorenewable.rawValue,
                                IAPProducts.nonRenewing.rawValue]
        
        let productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}

extension IAPManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        products.forEach { print($0.localizedTitle) }
    }
}
