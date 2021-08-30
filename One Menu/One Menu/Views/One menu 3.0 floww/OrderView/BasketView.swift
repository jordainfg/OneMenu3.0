//
//  OrderConsumableView.swift
//  OrderConsumableView
//
//  Created by Jordain on 13/08/2021.
//https://www.hackingwithswift.com/books/ios-swiftui/dynamically-filtering-a-swiftui-list
// https://www.behance.net/gallery/100227815/Restaurant-dine-in-pickup-app-ui-kit

import SwiftUI
import SDWebImageSwiftUI


class OrderModel : ObservableObject{
   
    @Published var newOrder : Order = Order.default
    
   // @Published var selectedMenuItem : menuItem 
}


struct BasketView: View {
    
    @ObservedObject var store : DataStore
    
    @StateObject var orderModel = OrderModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    //Delivery
    @State private var streetAndHouseNumber : String = ""
    @State private var postalCode : String = ""
    @State private var city: String = ""
    @State private var note: String = ""
    
    @State var showTablePickerWheel = false
    @State var selectedTable = 0
    var tableNumbers = [0,2,3,4,5]
    
    @State var showDeliveryOptions = false
    
    @State var showAddMenuItemSheet = false
    
    @State var selectedItem : menuItem?
    var body: some View {
        NavigationView {
                Form {
                    
                    Section(header: Text("Order type")){
                     
                        Picker(selection: self.$orderModel.newOrder.orderType, label: Text("")) {
                            ForEach(orderType.allCases, id: \.rawValue) { value in
                                Text(value.localizedName)
                                    .tag(value)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: orderModel.newOrder.orderType, perform: { (value) in
                            withAnimation {
                                showTablePickerWheel = value == orderType.seated ? true : false
                                print("\(value)")
                                showDeliveryOptions = value == orderType.delivery ? true : false
                            }
                        })
                      //  .padding(.vertical)
                        
                        
                        if showTablePickerWheel {
                            Picker(selection: $selectedTable,
                                   label: Text("Please select a table")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .padding()) {
                                        ForEach(0 ..< tableNumbers.count) {
                                            Text("\(self.tableNumbers[$0])")
                                        }
                                    }
                        }
                    }
                    
                    Section(header: Text("Personal details")){
                            TextField("First and last name", text: $name).disableAutocorrection(true)
                            TextField("Email address", text: $email).disableAutocorrection(true)
                            TextField("Phone number", text: $phoneNumber).disableAutocorrection(true)
                            if showDeliveryOptions {
                                TextField("Street and house number", text: $streetAndHouseNumber).disableAutocorrection(true)
                                TextField("Post code", text: $postalCode).disableAutocorrection(true)
                                TextField("Phone number", text: $city).disableAutocorrection(true)
                                TextField("Phone number", text: $note).disableAutocorrection(true)
                            }
                        }
                    
                    Section(header:Text("Order items")){
                            ForEach(self.$orderModel.newOrder.menuItems, id : \.id) { item in
                                Text("")
                                NavigationLink(destination: EditMenuItemView(menuItem: item, menuItems: .constant([]), store: store)){
                                    itemRow(menuItem: item)
                                }
    //
                            }.onDelete(perform: removeRows)
                            
                            
                            HStack{
                                Text("Order total").fontWeight(.bold).foregroundColor(Color.blue)
                                Spacer()
                                Text("\(calculateOrdeTotal(menuItems: self.orderModel.newOrder.menuItems))")
                            }
                            .padding(.vertical,10)
                            
                        }
                      
                    }
                    .padding(.bottom, 60)
                    .overlay(
                        VStack {
                            Button(action: {}
                                   , label: {
                                HStack {
                                    Label("Checkout ", systemImage: "creditcard.fill")
                                    Text("€ \(String(format: "%.2f", orderModel.newOrder.subTotal))").foregroundColor(Color("whiteToBlack").opacity(0.5))
                                }
                            })
                            .buttonStyle(VibrantActionButtonStyle())
                            .padding(10)
                        }
                        .background(Color("whiteToBlack"))
                        .frame(maxWidth:.infinity)
                        , alignment: .bottom
                    )
                    .onAppear{
                        self.orderModel.newOrder.menuItems = store.cartItems
                    }
                    .navigationBarTitle("Basket", displayMode: .inline)
                    .navigationBarItems(leading: BarItemButton(systemName: "arrow.triangle.2.circlepath"){
                        presentationMode.wrappedValue.dismiss()
                    }, trailing: HStack {
                        Button(action: { }, label: {Text("Clear")})
                        EditButton()
                    })
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        self.orderModel.newOrder.menuItems.remove(atOffsets: offsets)
    }
    
    func calculateOrdeTotal(menuItems : [menuItem]) -> String {
        var orderTotal : Double = 0.00
        for menuItem in menuItems {
            var totalForMenuItem : Double = menuItem.price
            for option in menuItem.options where option.enabled == true {
                totalForMenuItem += Double(option.price) ?? 00.00
            }
            for extra in menuItem.extras where extra.enabled == true {
                totalForMenuItem += Double(extra.price) ?? 00.00
            }
            
            totalForMenuItem = totalForMenuItem * Double(menuItem.quantity)
            orderTotal = orderTotal + totalForMenuItem
        }
        
        return String(format: "%.2f", orderTotal)
        
    }
}

//struct BasketView_Previews: PreviewProvider {
//    static var previews: some View {
//        BasketView()
//    }
//}
