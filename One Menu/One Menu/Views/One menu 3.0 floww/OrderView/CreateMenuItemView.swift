//
//  CreateMenuItemView.swift
//  CreateMenuItemView
//
//  Created by Jordain on 16/08/2021.
//

import SwiftUI


struct CreateMenuItemView: View {
    
    @State var menuItem : menuItem
    
    @State var consumable : Consumable
    
    @State private var favoriteColor = 0
    
    @State var showCustomizations = false
    
    @Binding var menuItems : [menuItem]
    
    @State var newMenuItems : [menuItem] = []
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store : DataStore
    var body: some View {
        
        ScrollView {
            ScrollViewReader { value in
                
                StrechyImageHeader()
                VStack(alignment:.leading, spacing: 25){
                    
                    VStack(alignment:.leading, spacing: 15) {
                        Text(menuItem.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(menuItem.subTitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    if consumable.hasNutrition {
                    VStack(alignment:.leading, spacing: 15) {
                        
                        SectionText2(text: "Nutrional facts")
                        
                        HStack{
                            
                            ValueBlockView(value: consumable.calories, unit: "kcal")
                            Spacer()
                            ValueBlockView(value: consumable.protein, unit: "proteins")
                            Spacer()
                            ValueBlockView(value: consumable.carbs, unit: "carbs")
                            Spacer()
                            ValueBlockView(value: consumable.fat, unit: "fats")
                            
                        }
                        .padding()
                        .frame(maxWidth:.infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                        
                    
                        Text("*Actual values may differ.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    }
                    
                    VStack(alignment:.leading, spacing: 15) {
                        
                        SectionText2(text: "Would you like to customize?")
                        
                        Picker(selection: $menuItem.type, label: Text("")) {
                            ForEach(menuItemType.allCases, id: \.rawValue) { value in
                                Text(value.localizedName)
                                    .tag(value)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: menuItem.type, perform: { (value) in
                            withAnimation {
                                menuItem.type = value
                                showCustomizations = value == .custom ? true : false
                            }
                            guard value == .custom else {
                                menuItem.options.indices.forEach { menuItem.options[$0].enabled = false }
                                menuItem.extras.indices.forEach { menuItem.extras[$0].enabled = false }
                                return
                            }
                            
                        })
                        .onAppear{
                            showCustomizations = menuItem.type == .custom ? true : false
                        }
                    }
                    
                if showCustomizations {
                    Divider()
                        
                    VStack(alignment:.leading, spacing: 15) {
                        
                        SectionText2(text: "Customize to your liking")
                        
                        VStack {
                            ForEach(menuItem.options.indexed(), id: \.1.id) { index, option in
                                Toggle( isOn: $menuItem.options[index].enabled.didSet { (state) in
                                    withAnimation{
                                    menuItem.options[index].enabled = state
                                    print( menuItem.options[index].enabled)
                                   
                                        value.scrollTo(0, anchor: .bottom)
                                    }
                                }) {
                                    HStack(alignment:.center){
                                        Text("\(option.name)").font(.body)
                                        Text("(+\(option.price))").font(.footnote).foregroundColor(.secondary)
                                    }.padding(.vertical,10)
                                    
                                }.toggleStyle(SwitchToggleStyle(tint: Color.black))
                                
                            }
                        }
                        .padding()
                        .background(Color("grouped"))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                        
                        Divider()
                        
                    VStack(alignment:.leading, spacing: 15) {
                        SectionText2(text: "Would you like to add something more?")
                        VStack {
                            ForEach(menuItem.extras.indexed(), id: \.1.id) { index, extra in
                                Toggle( isOn: $menuItem.extras[index].enabled.didSet { (state) in
                                    withAnimation{
                                    menuItem.extras[index].enabled = state
                                    print( menuItem.extras[index].enabled)
                                    
                                        value.scrollTo(0, anchor: .bottom)
                                    }
                                    
                                }) {
                                    HStack(alignment:.center){
                                        Text("\(extra.name)").font(.body)
                                        Text("(+\(extra.price))").font(.footnote).foregroundColor(.secondary)
                                    }.padding(.vertical,10)
                                    
                                }.toggleStyle(SwitchToggleStyle(tint: Color.black))
                                
                            }
                        }
                        .padding()
                        .background(Color("grouped"))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                }
                    
                    Divider()
                    
                    VStack(alignment:.leading, spacing: 15) {
                        SectionText2(text: "Summary")
                        
                        menuItemSummaryForCustomOrStandard(menuItem: $menuItem)
                            .padding()
                            .background(Color("grouped"))
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                
                }
                .id(0)
                .padding()
                .padding(.bottom,60)
                
            }
           
        }
        .overlay(
            BottomBarButton( name: "Add to basket", systemName: "bag", aditionalText: "(\(String(format: "%.2f", menuItem.price)))"){
                store.cartItems.append(menuItem)
        }
           
            , alignment: .bottom
      )
    }
    
    
}




struct EditMenuItemView: View {
    
    @Binding var menuItem : menuItem
    
   
    @State private var favoriteColor = 0
    
    @State var showCustomizations = false
    
    @Binding var menuItems : [menuItem]
    
    @State var newMenuItems : [menuItem] = []
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store : DataStore
    var body: some View {
        
        ScrollView {
            ScrollViewReader { value in
                
                StrechyImageHeader()
                VStack(alignment:.leading, spacing: 25){
                    
                    VStack(alignment:.leading, spacing: 15) {
                        Text(menuItem.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(menuItem.subTitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    if menuItem.consumable.hasNutrition {
                    VStack(alignment:.leading, spacing: 15) {
                        
                        SectionText2(text: "Nutrional facts")
                        
                        HStack{
                            
                            ValueBlockView(value: menuItem.consumable.calories, unit: "kcal")
                            Spacer()
                            ValueBlockView(value: menuItem.consumable.protein, unit: "proteins")
                            Spacer()
                            ValueBlockView(value: menuItem.consumable.carbs, unit: "carbs")
                            Spacer()
                            ValueBlockView(value: menuItem.consumable.fat, unit: "fats")
                            
                        }
                        .padding()
                        .frame(maxWidth:.infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                        
                    
                        Text("*Actual values may differ.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    }
                    
                    VStack(alignment:.leading, spacing: 15) {
                        
                        SectionText2(text: "Would you like to customize?")
                        
                        Picker(selection: $menuItem.type, label: Text("")) {
                            ForEach(menuItemType.allCases, id: \.rawValue) { value in
                                Text(value.localizedName)
                                    .tag(value)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: menuItem.type, perform: { (value) in
                            withAnimation {
                                menuItem.type = value
                                showCustomizations = value == .custom ? true : false
                            }
                            guard value == .custom else {
                                menuItem.options.indices.forEach { menuItem.options[$0].enabled = false }
                                menuItem.extras.indices.forEach { menuItem.extras[$0].enabled = false }
                                return
                            }
                            
                        })
                        .onAppear{
                            showCustomizations = menuItem.type == .custom ? true : false
                        }
                    }
                    
                if showCustomizations {
                    Divider()
                        
                    VStack(alignment:.leading, spacing: 15) {
                        
                        SectionText2(text: "Customize to your liking")
                        
                        VStack {
                            ForEach(menuItem.options.indexed(), id: \.1.id) { index, option in
                                Toggle( isOn: $menuItem.options[index].enabled.didSet { (state) in
                                    withAnimation{
                                    menuItem.options[index].enabled = state
                                    print( menuItem.options[index].enabled)
                                   
                                        value.scrollTo(0, anchor: .bottom)
                                    }
                                }) {
                                    HStack(alignment:.center){
                                        Text("\(option.name)").font(.body)
                                        Text("(+\(option.price))").font(.footnote).foregroundColor(.secondary)
                                    }.padding(.vertical,10)
                                    
                                }.toggleStyle(SwitchToggleStyle(tint: Color.black))
                                
                            }
                        }
                        .padding()
                        .background(Color("grouped"))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                        
                        Divider()
                        
                    VStack(alignment:.leading, spacing: 15) {
                        SectionText2(text: "Would you like to add something more?")
                        VStack {
                            ForEach(menuItem.extras.indexed(), id: \.1.id) { index, extra in
                                Toggle( isOn: $menuItem.extras[index].enabled.didSet { (state) in
                                    withAnimation{
                                    menuItem.extras[index].enabled = state
                                    print( menuItem.extras[index].enabled)
                                    
                                        value.scrollTo(0, anchor: .bottom)
                                    }
                                    
                                }) {
                                    HStack(alignment:.center){
                                        Text("\(extra.name)").font(.body)
                                        Text("(+\(extra.price))").font(.footnote).foregroundColor(.secondary)
                                    }.padding(.vertical,10)
                                    
                                }.toggleStyle(SwitchToggleStyle(tint: Color.black))
                                
                            }
                        }
                        .padding()
                        .background(Color("grouped"))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                }
                    
                    Divider()
                    
                    VStack(alignment:.leading, spacing: 15) {
                        SectionText2(text: "Summary")
                        
                        menuItemSummaryForCustomOrStandard(menuItem: $menuItem)
                            .padding()
                            .background(Color("grouped"))
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                
                }
                .id(0)
                .padding()
                .padding(.bottom,60)
                
            }
           
        }
        .overlay(
            BottomBarButton( name: "Add to basket", systemName: "bag", aditionalText: "(\(String(format: "%.2f", menuItem.price)))"){
                store.cartItems.append(menuItem)
        }
           
            , alignment: .bottom
      )
    }
    
    
}






struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {
    typealias Index = Base.Index
    typealias Element = (index: Index, element: Base.Element)
    
    let base: Base
    
    var startIndex: Index { base.startIndex }
    
    var endIndex: Index { base.endIndex }
    
    func index(after i: Index) -> Index {
        base.index(after: i)
    }
    
    func index(before i: Index) -> Index {
        base.index(before: i)
    }
    
    func index(_ i: Index, offsetBy distance: Int) -> Index {
        base.index(i, offsetBy: distance)
    }
    
    subscript(position: Index) -> Element {
        (index: position, element: base[position])
    }
}

extension RandomAccessCollection {
    func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }
}

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
}
struct StrechyImageHeader : View{
    
    let screen = UIScreen.main.bounds
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    // 2
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    var body : some View{
        
        
        VStack(alignment:.center){
            ZStack{
                GeometryReader { geometry in
                    
                    
                    Image("waffels")
                        .resizable()
                        .background(Color("grouped"))
                        .scaledToFill()
                        .overlay(TintOverlay().opacity(0.7))
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                        .cornerRadius(20, corners: [.bottomLeft,.bottomRight])
                        .clipped()
                        .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                    
                    
                    
                }
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .frame(height:screen.height/4 , alignment: .topLeading)
                .shadow(color: Color.primary.opacity(0.2), radius: 20, x: 0, y: 10)
                
            }
            
            
        }
        
        .edgesIgnoringSafeArea(.top)
        
    }
    
}




struct menuItemSummaryForCustomOrStandard: View {
    @Binding var menuItem : menuItem
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment:.leading, spacing: 20) {
                HStack {
                    
                    Text(menuItem.title).font(.body).fontWeight(.medium)
                    Spacer()
                    Text("\(String(format: "%.2f", menuItem.price))")
                }.padding(.vertical,10)
                
                if !menuItem.options.isEmpty ||  !menuItem.extras.isEmpty {
                    ForEach(menuItem.options.filter{ $0.enabled == true}, id: \.self) { option in
                    HStack {
                        Text(option.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(option.price)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }.transition(.opacity)
                        
                }
                   
                ForEach(menuItem.extras.filter{ $0.enabled == true}, id: \.self) { extra in
                    HStack {
                        Text(extra.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(extra.price)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }.transition(.opacity)
                }
                }
               
                
                Stepper(value: $menuItem.quantity, in: 1...1000) {
                    Text("Quantity \(menuItem.quantity)x").font(.caption)
                }
                
                Divider()
                
                
                HStack{
                    Text("Total").fontWeight(.bold).foregroundColor(Color.blue)
                    Spacer()
                    Text(calculateTotal(menuItem: menuItem))
                }.padding(.bottom,10)
                
            }.animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            //.padding()
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func calculateTotal(menuItem : menuItem) -> String {
        var grandTotal : Double = menuItem.price
        for option in menuItem.options where option.enabled == true {
            grandTotal += Double(option.price) ?? 00.00
        }
        for extra in menuItem.extras where extra.enabled == true {
            grandTotal += Double(extra.price) ?? 00.00
        }
        
        grandTotal = grandTotal * Double(menuItem.quantity)
        
        return String(format: "%.2f", grandTotal)
        
    }
}

struct ValueBlockView: View {
    var value : String
    var unit : String
    var body: some View {
        VStack(alignment: .center , spacing:5){
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
        }.padding(.vertical,5)
    }
}
