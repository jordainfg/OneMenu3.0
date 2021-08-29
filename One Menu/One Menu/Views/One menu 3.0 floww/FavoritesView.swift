//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Jordain on 25/08/2021.
//

import SwiftUI
import CoreData
import SDWebImageSwiftUI
struct FavoritesView: View {
    
    @ObservedObject var store : DataStore

    @Environment(\.managedObjectContext) private var viewContext
    
    @State var imagess : [String : WebImage] = [String: WebImage]()
    @FetchRequest(
        entity: FavoritedConsumable.entity(),
        sortDescriptors: []
    )
    
    var favoritedConsumables: FetchedResults<FavoritedConsumable>
    
    var segements :[viewsForScrollSegmentedControl] = [.meals,.beverages]
    @State  var selectedSegment : viewsForScrollSegmentedControl = .meals
    
    var body: some View {
       
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
                            ConsumableRow(item: consumable, image : imagess[consumable.consumableID])
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
                .toolbar {
                    EditButton()
                }
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
