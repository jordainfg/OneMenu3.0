//
//  ReadMe.swift
//  BaseSwiftUIAPP
//
//  Created by Jordain Gijsbertha on 29/07/2020.
//



// MARK: - @State and @Binding
/*
     1.  @State
         A State property is connected to the view (it can't be read anywhere else. A State property is permanently being read by the view. That means that every time the @State property gets changed/updated ( the view refreshes) , the view gets re-rendered and eventually displays the content depending on the @State's data.
         State is accessible only to a the view it's declared in.
     
     2.  @Binding
         Binding is used for for componets that are reused. A binding variable should not have a default value because the point of putting @Binding in front of the variable is to make it reusable(dynamic). Since it doesn't have a default value the variable becomes required. So you must give the binding variable a STATE or ( .constant(value) ) when you declare the component that the binding variable is in. Example Binding
 
            
        SomeotherView.swift:
        TestView(testvalue: .constant("s"))
        // or
        @State var value = "s"
        TestView(testvalue: $value))
        
 
        TestView.swift
                     struct TestView: View {
                        @Binding var testvalue : String
                         var body: some View {
                             Text(testvalue)
                         }
                     }

 
 */

// MARK: - @ObservedObject

/*
 
 1. What is @ObservedObject?
    This is very similar to @State except now we’re using an EXTERNAL reference type rather than a simple local property like a string or an integer. You’re still saying that your view depends on data that will change, except now it’s data you’re responsible for managing yourself – you need to create an instance of the class, create its own properties, and so on. See StateVsObservedObject.swift for an explanation.
 
 */
