//
//  Binding+extension.swift
//  Binding+extension
//
//  Created by Jordain on 30/08/2021.
//

import Foundation
import SwiftUI

extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
        func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
            return Binding(
                get: { self.wrappedValue },
                set: { selection in
                    self.wrappedValue = selection
                    handler(selection)
            })
        }
    
}
