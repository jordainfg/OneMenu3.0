//
//  StripePaymentModel.swift
//  StripePaymentModel
//
//  Created by Jordain on 05/08/2021.
//

import Foundation
import Stripe
import SwiftUI

class StripePaymentModel: ObservableObject {
  let backendCheckoutUrl = URL(string: "https://petalite-futuristic-caption.glitch.me/checkout")! // Your backend endpoint
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?

  init() {
    STPAPIClient.shared.publishableKey = "pk_test_51JFJGQAnNBKwLebeKUux8ZameDrg2FmfsSBW86G0MaWKTaCuNs5K8U6JxTBMHbCAHBbvebdGd5UcSDtG40JeNcoq00rtIfTaT6"
  }

  func preparePaymentSheet() {
    // MARK: Fetch the PaymentIntent and Customer information from the backend
    var request = URLRequest(url: backendCheckoutUrl)
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let customerId = json["customer"] as? String,
            let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
            let paymentIntentClientSecret = json["paymentIntent"] as? String,
            let self = self else {
        // Handle error
                print("error getting required data")
        return
      }

      // MARK: Create a PaymentSheet instance
      var configuration = PaymentSheet.Configuration()
      configuration.merchantDisplayName = "Example, Inc."
      configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)

      DispatchQueue.main.async {
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
      }
    })
    task.resume()
  }

  func onPaymentCompletion(result: PaymentSheetResult) {
    self.paymentResult = result
  }
}


