//
//  OrderConsumableView.swift
//  OrderConsumableView
//
//  Created by Jordain on 13/08/2021.
//https://www.hackingwithswift.com/books/ios-swiftui/dynamically-filtering-a-swiftui-list
// https://www.behance.net/gallery/100227815/Restaurant-dine-in-pickup-app-ui-kit

import SwiftUI

struct Consumable: Identifiable, Hashable,Codable  {
    var id :String
    var consumableID : String
    var headline : String
    var colorTone : String
    var image: String
    var title: String
    var subtitle: String
    var calories:String
    var price : Double
    var currency: String
    var carbs: String
    var carbsPercentage : Int
    var fat: String
    var fatPercentage : Int
    var protein: String
    var proteinPercentage : Int
    var extras : [String]
    var allergens : [String]
    var options : [String]
    var hasExtras : Bool
    var hasOptions: Bool
    var hasNutrition: Bool
    var hasIngredients : Bool
    var isPopular : Bool
    
    static let `default` = Consumable(id: "testID", consumableID: "testID", headline: "Vegan", colorTone: "", image: "", title: "Salmon Wafel", subtitle: "breakfast", calories: "3000", price: 12.0, currency: "$", carbs: "20g", carbsPercentage: 20, fat: "20g", fatPercentage: 30, protein: "20g", proteinPercentage: 30, extras: ["Mayo,€4.20", "Ketchup,€8.20", "Onion,€"], allergens: ["String"], options: ["Extra egg,€1.20", "Extra bacon,€3.20", "Pickels,€"], hasExtras: false, hasOptions: false, hasNutrition: false, hasIngredients: false, isPopular: false)
    
}


class OrderModel : ObservableObject{
   
    @Published var newOrder : Order = Order.default
    
    @Published var selectedMenuItem : menuItem = menuItem.default
}


struct OrderConsumableView: View {
    
    @StateObject var orderModel = OrderModel()
    
  
    @State var showTablePickerWheel = false
    @State var selectedTable = 0
    var tableNumbers = [0,2,3,4,5]
    
    
    @State var showAddMenuItemSheet = false
    @State var selectedItem : menuItem?
    var body: some View {
        NavigationView{
            
            
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
                        }
                    })
                    .padding()
                    
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
                Section(header:Text("Menu Items")){
                    ForEach(self.$orderModel.newOrder.menuItems) { item in

                        NavigationLink(destination: CreateMenuItemView(menuItem: item, menuItems: self.$orderModel.newOrder.menuItems)){
                            itemRow(menuItem: item)
                        }
                        
                    }
                    
//                    Button(action: {
//                        print(orderModel.newOrder.menuItems)
//                        print( self.orderModel.selectedMenuItem.options[0].enabled)
//                    }
//                    ) {
//                        Text("Print order")
//
//                    }
                    
                    HStack{
                        Text("Order total").fontWeight(.bold).foregroundColor(Color.blue)
                        Spacer()
                        Text("\(calculateOrdeTotal(menuItems: self.orderModel.newOrder.menuItems))")
                    }.padding(.vertical,10)
                }
              
            }.navigationTitle("Order")
            
            
        }
        
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

struct OrderConsumableView_Previews: PreviewProvider {
    static var previews: some View {
        OrderConsumableView()
    }
}
extension Optional where Wrapped == String {
    // * we added "where Wrapped == String" here because we only want to provide this functionality to string. If you want to provide this functionality to other types you can by adding an extension for that specific type. Because you need to return the correcct value.
    var orEmpty : String {
        switch self {
        case .some(let value):
            return value
        default:
            return ""
        }
    }
    // even more clean
    var emptyStr: String { return self ?? ""  }
}
