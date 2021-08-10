//
//  ManageConsumablesForCategorieView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 28/01/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ManageConsumablesForCategorieView: View {
    
    @Binding var collectionName : collectionName 
    @ObservedObject var store: AdminDataStore
    
    @State var selectedCategorie : ConsumableCategorie?
    
    @State var didUpdate : Bool = false
    
    @State var showingActionSheet : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var consumables : [Consumable]
    
    @State var allConsumables : [Consumable]  = []
    
    @State var selectedConsumables : [Consumable] = []
    
    @State var consumablesByID : [String] = []
    
    var columss = Array(repeating: GridItem(.adaptive(minimum: 150,maximum: 200), spacing: 20), count: 3)
    
    @Namespace private var animation
    
    @Namespace private var animation3
    
    let gradient = LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    let gradient2 = LinearGradient(gradient: Gradient(colors: [.red, .blue]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
    
    @Binding var imagess : [String : WebImage]
    
    
    var body: some View {
        
        NavigationView {
            ScrollView{
                
                HStack{
                    Text("\(collectionName == .Meals ? "Meals" : "Beverages") for this categorie")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Spacer()
                }.padding(.horizontal).padding(.top)
                
                if selectedConsumables.count == 0 {
                    Text("You don't have any \(collectionName == .Meals ? "meals" : "beverages") for this categorie. Add one by selecting a \(collectionName == .Meals ? "meal" : "beverage") below.").font(.footnote).foregroundColor(.secondary).padding(.horizontal).padding(.top)
                }
                LazyVGrid(columns:columss, spacing : 15){
                    
                    ForEach(self.selectedConsumables, id: \.self ) { consumable in
                        Button(action: {
                     
                                self.allConsumables.append(consumable)
                                withAnimation{
                                    didUpdate = true
                                }
                                self.selectedConsumables.removeAll {$0.consumableID == consumable.consumableID }
                                HapticService.shared.standard(type : .success)
                            
                        }) {
                            ConsumableCard(consumable:consumable, image : imagess[consumable.consumableID]).tag(consumable.id)
                                .matchedGeometryEffect(id: consumable.consumableID, in: animation)
                        }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                    }
                    
                }.padding(.all)
                .animation(.easeInOut)
                
                
                HStack{
                    Text("All \(collectionName == .Meals ? "Meals" : "Beverages")")
                        .font(.headline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.secondary)
                    Spacer()
                }.padding(.horizontal)
                
                
                
                LazyVGrid(columns:columss, spacing : 15){
                    
                    NavigationLink(destination: CreateConsumableView(showPopularToggle: true, consumables: $consumables, isPopular : false, store: store, imagess: $imagess)){
                        AddSpecialConsumableCard()
                    }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))

                    ForEach(self.allConsumables, id: \.self ) { consumable in
                        Button(action: {
                            self.selectedConsumables.append(consumable)
                            withAnimation{
                                didUpdate = true
                            }
                            self.allConsumables.removeAll {$0.consumableID == consumable.consumableID }
                            HapticService.shared.standard(type : .success)
                        }) {
                            ConsumableCard(consumable:consumable, image : imagess[consumable.consumableID]).tag(consumable.id)
                                .matchedGeometryEffect(id: consumable.consumableID, in: animation3)
                        }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                    }
                }.padding(.all)
                .animation(.easeInOut)
                
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) { Spacer() }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        if didUpdate{
                            updateCategorie()
                        }
                        
                    }, label: {
                        Text(didUpdate ? "Update" : "").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    })
                }
                
                ToolbarItem(placement: .bottomBar) { Spacer() }
                
            }
            .navigationBarTitle("\(selectedCategorie?.title ?? "Categorie")")
            .navigationBarItems(leading:Button(action: {
                
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            },trailing:
                Button(action: {
                    showingActionSheet = true
                    
                }) {
                    Image(systemName: "trash.fill")
                        .renderingMode(.original)
                        .font(.title)
                }
                
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Confirmation"), message: Text("\(selectedCategorie?.title ?? "This categorie") will be deleted. Are you sure you want to delete this category? Meals for this category will not be deleted."), buttons: [
                        
                        .destructive(Text("Delete").foregroundColor(.red)) {deleteCategorie()},
                        .default(Text("Cancel")) {}
                    ])
                }
            )
            .onAppear{
                if let selectedCategorie = selectedCategorie {
                    allConsumables = consumables
                    consumablesByID = selectedCategorie.consumablesByID
                    selectedConsumables = allConsumables.filter { consumablesByID.contains($0.consumableID)}
                    allConsumables = allConsumables.filter { !consumablesByID.contains($0.consumableID)}
                }
            }
        }
        
    }
    
    func updateCategorie(){
        setConsumablesByID()
        if var selectedCategorie = selectedCategorie {
            selectedCategorie.consumablesByID = consumablesByID
            store.updateConsumableCategorie(selectedCategorie: selectedCategorie, consumablesByID: consumablesByID) { result in
                switch result {
                case .success:
                    presentationMode.wrappedValue.dismiss()
                case .failure:
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func deleteCategorie(){
        if let selectedCategorie = selectedCategorie {
            
            store.deleteCategorie( selectedCategorie: selectedCategorie) { result in
                switch result {
                case .success:
                    presentationMode.wrappedValue.dismiss()
                case .failure:
                    presentationMode.wrappedValue.dismiss()
                }
                
            }
        }
    }
    func setConsumablesByID(){
        consumablesByID.removeAll()
        for consumable in selectedConsumables {
            consumablesByID.append(consumable.consumableID)
        }
    }
}
//
//struct ManageConsumablesForCategorieView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManageConsumablesForCategorieView()
//    }
//}
