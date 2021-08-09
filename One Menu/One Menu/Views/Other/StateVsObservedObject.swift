//
//  ApiTestView.swift
//  BaseSwiftUIAPP (iOS)
//
//  Created by Jordain Gijsbertha on 30/07/2020.
//

import SwiftUI



// MARK: - Documentation
/*
 
 1.This uses @ObservedObject, if you try typing in the textfield the text will change. But if this was a state the text won't change. Whatever type you use with @ObservedObject should conform to the ObservableObject protocol. There are several ways for an observed object to notify views that important data has changed, but the easiest is using the @Published property wrapper
 
 */
class User : ObservableObject{
    @Published  var firstName = "Bilbo"
    @Published var lastName = "Baggins"
    
}

struct StateVsObservedObject: View {
    @ObservedObject  var user = User()
    var body: some View {
        
        VStack(spacing:20) {
            Text("Your name is \(user.firstName) \(user.lastName).")
            
            TextField("First name", text: $user.firstName)
                .background(Color.blue
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
            TextField("Last name", text: $user.lastName)
                .background(Color.blue
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
            
            test(label: $user.firstName)

        }
        
        
    }
}

struct StateVsObservedObject_Previews: PreviewProvider {
    static var previews: some View {
        StateVsObservedObject()
    }
}


struct test: View {
  @Binding var label : String
    var body: some View {
        Text(label)
    }
}
