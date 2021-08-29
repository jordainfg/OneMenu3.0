//
//  Enums.swift
//  Enums
//
//  Created by Jordain on 29/08/2021.
//

import Foundation
import SwiftUI

enum alerts: Identifiable {
    case showSuccessAlert, showFailedAlert,showValidationAlert,showSubscribeAlert
    
    var id: Int {
        hashValue
    }
}
