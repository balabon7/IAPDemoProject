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
    
    
    static let productNotificationIdentifire = "IAPManagerProductIdentifire"
    static let shared = IAPManager()
    
    private override init() { }
    
    var products: [SKProduct] = []
    
    public func setupPurchases(callback: @escaping(Bool) -> ()) {
        // проверка устройства на осуществление платежа
        if SKPaymentQueue.canMakePayments()  {
            //устанавляваем .add(self) что бы мы могли добавить себя в качестве наблюдателя
            SKPaymentQueue.default().add(self)
            callback(true)
            return
        }
        callback(false)
    }
    
    // Получаем товары по запросу с идентификатором
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
 // Реализуем обязательный метод
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}

extension IAPManager: SKProductsRequestDelegate {
    // Реальзуем метод который дает нам ответ от сервера и добавляет товат в масив
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        products.forEach { print($0.localizedTitle) }
        
        if products.count > 0 {
            NotificationCenter.default.post(name: NSNotification.Name(IAPManager.productNotificationIdentifire), object: nil)
            
        }
    }
}
