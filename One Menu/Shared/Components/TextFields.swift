//
//  TextFields.swift
//  TextFields
//
//  Created by Jordain on 29/08/2021.
//

import Foundation
import SwiftUI

struct textFieldWithDoneButton: View {
    @State var name : String
    @State var placeHolder : String
    @Binding var text : String
    @State var isEditing : Bool = false
    @State var trailingText : String = ""
    @State var keyBoardType :  UIKeyboardType = .default
    var body: some View {
        HStack{
            Text(name).font(.subheadline).foregroundColor(.secondary)
            Spacer()
            TextField(placeHolder, text: $text , onEditingChanged: { (changed) in
                if changed {
                    isEditing = true
                } else {
                    isEditing = false
                }
            })
            .keyboardType(keyBoardType).foregroundColor(.secondary)
            if text.count > 0 && isEditing{
                Button(action: {
                    // your action here
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    isEditing = false
                }) {
                    Text("Done").font(.body).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
            }
            Text(trailingText).font(.footnote).foregroundColor(.secondary).fontWeight(.semibold)
        }
    }
}



