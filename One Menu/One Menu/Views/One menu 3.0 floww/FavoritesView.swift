//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Jordain on 25/08/2021.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    
    @ObservedObject var store : DataStore

    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
        entity: FavoritedConsumable.entity(),
        sortDescriptors: []
    )
    
    var favoritedConsumables: FetchedResults<FavoritedConsumable>
    
    var segements :[viewsForScrollSegmentedControl] = [.meals,.beverages]
    @State  var selectedSegment : viewsForScrollSegmentedControl = .meals
    
    var body: some View {
       
        NavigationView {
            VStack{
                    Picker(selection: $selectedSegment.animation(), label: Text("")) {
                        ForEach(segements, id: \.self) { segment in
                            Text(segment.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    List {
                        ForEach(store.consumables.filter { consumable in
                            
                            favoritedConsumables.contains(where: {
                                $0.consumableID == consumable.consumableID &&
                                $0.restaurantID == store.selectedRestaurant!.restaurantID &&
                                $0.isMeal == (selectedSegment == .meals)
                            })
                            
                        })
                        { consumable in
                            NavigationLink(destination: SelectedMenuItemView(menuItem: menuItem(consumable: consumable), consumable: consumable, store: store, image: store.imagess[consumable.consumableID]), label: {
                                ConsumableRow(item: consumable, image : store.imagess[consumable.consumableID])
                            })
                        }
                        .onDelete(perform: delete)
                    }
                    .navigationBarTitle("Favorites", displayMode: .inline)
                    .navigationBarItems(leading: BarItemButton(systemName: "arrow.triangle.2.circlepath"){
                        presentationMode.wrappedValue.dismiss()
                    })
                    .listStyle(PlainListStyle())
                    .toolbar {EditButton()}
                    .overlay(Group {
                                    if !favoritedConsumables.contains(where: {
                                       
                                        $0.restaurantID == store.selectedRestaurant!.restaurantID
                                    }
                                    ) {
                                        VStack {
                                            Text("Looks like you don't have any favorites yet. You can favorite meals and beverages by tapping the hart when browsing meals.")
                                                .multilineTextAlignment(.center)
                                        }.padding()
                                    }
                    })
                
            }
        }
        
    }
    
    func delete(at indexSet: IndexSet) {
        for index in indexSet {
            viewContext.delete(favoritedConsumables[index])
        }
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

}
