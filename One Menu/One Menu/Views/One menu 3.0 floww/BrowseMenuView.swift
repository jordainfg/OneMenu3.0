//
//  BrowseMenuView.swift
//  BrowseMenuView
//
//  Created by Jordain on 24/08/2021.
//

import SwiftUI
import CoreData

struct BrowseMenuView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
   
    @ObservedObject var store : DataStore
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ConsumableBrowseList(consumables: store.consumables,
                                 categorys: store.consumableCategories,
                                 filterKeysForConsumable: \.title,
                                 filterKeysForCategorie: \.title,
                                 consumablerowContent: { consumable in
                                    NavigationLink(destination: SelectedMenuItemView(menuItem: menuItem(consumable: consumable), consumable: consumable, store: store, image: store.imagess[consumable.consumableID]), label: {
                                        ConsumableRow(item: consumable, image : store.imagess[consumable.consumableID])
                                    })
                                 },
                                 categoryrowContent : { category in
                                    VStack(alignment: .leading) {
                                        Text(category.title)
                                            .font(.headline)
                                        Text(category.subtitle)
                                            .foregroundColor(.secondary)
                                    }}
                                )
                .navigationBarTitle("Browse", displayMode: .inline)
                .navigationBarItems(leading: BarItemButton(systemName: "arrow.triangle.2.circlepath"){
                    presentationMode.wrappedValue.dismiss()
                })
        }
        
    }
}

//struct BrowseMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            BrowseMenuView()
//        }
//    }
//}

enum viewsForScrollSegmentedControl : LocalizedStringKey {
    case meals = "Meals"
    case beverages = "Beverages"
    case categories = "Categories"
}

struct ConsumableBrowseList<consumableContent:View, categoryContent:View> : View{
    
    @State private var searchedConsumables = [Consumable]()
    @State private var searchedCategories = [ConsumableCategorie]()
    @State private var searchText = ""
    
    var segements :[viewsForScrollSegmentedControl] = [.meals,.beverages,.categories]
    @State  var selectedSegment : viewsForScrollSegmentedControl = .meals
    
    
    
    let searchableConsumables : [Consumable] // Users,Meals,Beverages etc.
    let searchableCategories : [ConsumableCategorie]
    
    let filterKeyPathsForConsumable: [KeyPath<Consumable,String>] // properties of a searchable Consumable
    let filterKeyPathsForCategory: [KeyPath<ConsumableCategorie,String>] // properties of a searchable Consumable
    
    let consumableRow : (Consumable) -> consumableContent
    let categoryRow : (ConsumableCategorie) -> categoryContent
    
    /// Example with users UserForList(name: "Jordain", company: "Apple", email: "jord=@gmail.com", phone: "0638482214", address: "Joonchi")
    /// - Parameters:
    ///   - data: Users,Meals,Beverages etc.
    ///   - filterKeys: Properties of data: for example for user it can be name.
    ///   - rowContent: VStack {  Text(user.name).font(.headline)  }
    init( consumables: [Consumable],
          categorys: [ConsumableCategorie],
          filterKeysForConsumable: KeyPath<Consumable, String>...,
          filterKeysForCategorie: KeyPath<ConsumableCategorie, String>...,
          @ViewBuilder consumablerowContent: @escaping (Consumable) -> consumableContent,
          @ViewBuilder categoryrowContent: @escaping (ConsumableCategorie) -> categoryContent
    ) {
        searchableConsumables = consumables
        searchableCategories = categorys
        filterKeyPathsForConsumable = filterKeysForConsumable
        filterKeyPathsForCategory = filterKeysForCategorie
        consumableRow = consumablerowContent
        categoryRow = categoryrowContent
    }
    
    var body: some View{
        VStack(spacing:0) {
            CustomSearchBar(text: selectedSegment == .beverages || selectedSegment == .meals ? $searchText.onChange(applyFilterForConsumable) : $searchText.onChange(applyFilterForCategory))
            Picker(selection: $selectedSegment.animation(), label: Text("")) {
                ForEach(segements, id: \.self) { segment in
                    Text(segment.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
            .onReceive([self.selectedSegment].publisher.first()) { value in
                //                switch selectedSegment{
                //
                //                case .meals:
                //
                //                case .beverages:
                //                    <#code#>
                //                case .categories:
                //                    <#code#>
                //                }
            }
            .padding(.horizontal)
            
            TabView(selection: $selectedSegment) {
                List(searchedConsumables.filter{$0.isMeal == true}, rowContent: consumableRow)
                    .listStyle(PlainListStyle())
                    .onAppear(perform: applyFilterForConsumable)
                    .tag(viewsForScrollSegmentedControl.meals)
                
                List(searchedConsumables.filter{$0.isMeal == false}, rowContent: consumableRow)
                    .listStyle(PlainListStyle())
                    .onAppear(perform: applyFilterForConsumable)
                    .tag(viewsForScrollSegmentedControl.beverages)
                
                List(searchedCategories, rowContent: categoryRow)
                    .listStyle(PlainListStyle())
                    .onAppear(perform: applyFilterForCategory)
                    .tag(viewsForScrollSegmentedControl.categories)
                
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
        }
        //.navigationBarSearch($searchText.onChange(applyFilter))
    }
    
    
    func applyFilterForConsumable() {
        let cleanedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedSearchText.isEmpty {
            searchedConsumables = searchableConsumables
        } else {
            searchedConsumables = searchableConsumables.filter { element in
                filterKeyPathsForConsumable.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(cleanedSearchText)
                }
            }
        }
    }
    func applyFilterForCategory() {
        let cleanedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedSearchText.isEmpty {
            searchedCategories = searchableCategories
        } else {
            searchedCategories = searchableCategories.filter { element in
                filterKeyPathsForCategory.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(cleanedSearchText)
                }
            }
        }
    }
}

struct CustomSearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .padding(.leading, 10)
                TextField("Meals,beverages,categories", text: $text)
                    .padding(.vertical,8)
                    .onTapGesture {
                        withAnimation{
                            self.isEditing = true
                        }
                    }
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            
            if isEditing {
                Button(action: {
                    withAnimation{
                        self.isEditing = false
                        self.text = ""
                    }
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }.padding(.vertical,10)
    }
}


//            Button(action: {
//                let newFavorite = FavoritedConsumable(context: viewContext)
//                newFavorite.consumableID = consumable.consumableID
//                newFavorite.restaurantID = store.selectedRestaurant?.restaurantID ?? "e"
//                newFavorite.isMeal = consumable.isMeal
//                newFavorite.id = UUID()
//                do {
//                        try viewContext.save()
//                        print("Consumable saved to favorites")
//
//
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//
//
//            }, label: {
////                VStack(alignment: .leading) {
////                Text(consumable.title)
////                    .font(.headline)
////                Text(consumable.subtitle)
////                    .foregroundColor(.secondary)
////                }
//                ConsumableRow(item: consumable, image : imagess[consumable.consumableID])
//
//            })
//
