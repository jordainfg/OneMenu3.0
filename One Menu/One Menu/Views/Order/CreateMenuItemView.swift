//
//  CreateMenuItemView.swift
//  CreateMenuItemView
//
//  Created by Jordain on 16/08/2021.
//

import SwiftUI


struct CreateMenuItemView: View {
    
    @Binding var menuItem : menuItem
    
    @State private var favoriteColor = 0
    
    @State var showCustomizations = false
    
    @Binding var menuItems : [menuItem]
    
    @State var newMenuItems : [menuItem] = []
    
    var body: some View {
            List {
                StrechyImageHeader() .listRowInsets(EdgeInsets())
                
                Section(header:Text("Would you like to customize?")){
                    Picker(selection: $menuItem.type, label: Text("")) {
                        ForEach(menuItemType.allCases, id: \.rawValue) { value in
                            Text(value.localizedName)
                                .tag(value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: menuItem.type, perform: { (value) in
                        withAnimation {
                            menuItem.type = value
                            
                            showCustomizations = value == .custom ? true : false
                            
                        }
                    })
                    .onAppear{
                        showCustomizations = menuItem.type == .custom ? true : false
                    }
                }
                if showCustomizations {
            Section(header:Text("Customize to your liking")){
                
                ForEach(menuItem.options.indexed(), id: \.1.id) { index, option in
                    Toggle( isOn: $menuItem.options[index].enabled.didSet { (state) in
                        menuItem.options[index].enabled = state
                        print( menuItem.options[index].enabled)
                    }) {
                        HStack{
                            Text("\(option.name)").font(.body)
                            Text("(+\(option.price))").font(.footnote).foregroundColor(.secondary)
                        }
                        
                    }.toggleStyle(SwitchToggleStyle(tint: Color.red))
                }}
                
            Section(header:Text("Would you like to add something more?")){
                
                ForEach(menuItem.extras.indexed(), id: \.1.id) { index, extra in
                    Toggle( isOn: $menuItem.extras[index].enabled.didSet { (state) in
                        menuItem.extras[index].enabled = state
                        print( menuItem.extras[index].enabled)
                    }) {
                        HStack{
                            Text("\(extra.name)").font(.body)
                            Text("(+\(extra.price))").font(.footnote).foregroundColor(.secondary)
                        }
                        
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.red))
                }
            }
                }
         
                Section(header:Text("Summary")){
                    
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(menuItem.name)
                                Spacer()
                                Text("\(String(format: "%.2f", menuItem.price))")
                            }
                            .padding(.bottom,10)
                            
                            ForEach(menuItem.options.filter{ $0.enabled == true}, id: \.self) { option in
                                HStack {
                                    Text(option.name)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("\(option.price)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
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
                                }
                            }
                            
                            Divider()
                                .padding(.top,10)
                            
                            Stepper(value: $menuItem.quantity, in: 1...1000) {
                                Text("Quantity \(menuItem.quantity)")
                            }.padding(.vertical,10)
                            
                            Divider()
                                
                            
                            HStack{
                                Text("Total")
                                Spacer()
                                Text(calculateTotal(menuItem: menuItem))
                            }.padding(.vertical,10)
                            
                        }
                        .padding()
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(menuItem.name).font(.headline).fontWeight(.bold).foregroundColor(Color.black).lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            //.listStyle(PlainListStyle())
        
    }
    
    func calculateTotal(menuItem : menuItem) -> String {
        
        return "$300"
        
    }
}

struct CreateMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CreateMenuItemView(menuItem: .constant(menuItem.default), menuItems: .constant(menuItem.all))
        }
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
                            .overlay(TintOverlay().opacity(0.3))
                            .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                            .clipped()
                            .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                            
                    
                    
                }
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .frame(height:screen.height/3.5 , alignment: .topLeading)
                .shadow(color: Color.primary.opacity(0.2), radius: 20, x: 0, y: 10)
                
            }
            
            
        }
        
        .edgesIgnoringSafeArea(.top)
        
    }
    
}


struct TintOverlay: View {
  var body: some View {
    ZStack {
      Text(" ")
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .background(Color.black)
  }
}
