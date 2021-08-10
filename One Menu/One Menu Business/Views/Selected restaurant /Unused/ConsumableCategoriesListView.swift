//
//  CategoriesListView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 26/01/2021.
//

import SwiftUI

struct ConsumableCategoriesListView: View {
    @ObservedObject var store: AdminDataStore
    
    @State var presentCreateConsumables : Bool = false
    
    @State var  viewState : viewState = .isLoading
    @State var createSumButtonPressed = false
    
    @State var language : languageType = .Dutch
    @State var collectionName : collectionName = .Meals
    func getCategories(){
        viewState = .isLoading
       
        store.getConsumableCategories(collectionName: collectionName, languageType: language){ result in
            switch result {
            case .success:
                viewState = .dataAvailable
            case .failure:
                viewState = .noDataAvailable
                print("Fail")
            }
        }
        
    }
    
    var body: some View {
        ZStack{
            switch viewState{
            
            case .isLoading:
                loading.onAppear{
                  
                        getCategories()
                    
                }.environment(\.locale, Locale(identifier: store.language))
                .smoothTransition()
            case .dataAvailable:
                
                content.smoothTransition()
                
            case .noDataAvailable:
                VStack(spacing:10){
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .renderingMode(.template)
                        .font(.largeTitle)
                        .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                    Text(LocalizedStringKey("tryagain"))
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                }
                .smoothTransition()
                .padding(.top)
                .onTapGesture{
                    getCategories()
                    
                }
            default:
                loading
            }
        }.navigationBarTitle("Categories",displayMode: .inline)
    }
    
    
    var loading : some View{
        VStack{
            if #available(iOS 14, *) {
                CustomProgressView()
            } else {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            }
        }.frame(maxWidth:.infinity)
        .frame(height: 50)
    }
    var content: some View {
        List{
            
            if store.consumableCategories.isEmpty{
                HStack {
                    Spacer()
                    Text("No categories yet").font(.footnote).foregroundColor(.secondary)
                    Spacer()
                }
            }
          
            ForEach(store.consumableCategories, id: \.self ) { categorie in
                categorieRow(categorie:categorie, store: store)
            }
            .onDelete(perform: deleteRequestFromFirestore)
            
            

        }
        .sheet(isPresented: $presentCreateConsumables, content: {
            CreateConsumableCategorieView(store: store, language:language)
        })
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button(action: {
            presentCreateConsumables = true
        }) {
            Text("Add")
        })
    }
    private func deleteRequestFromFirestore(at offsets: IndexSet) {
        
            store.consumableCategories.remove(atOffsets: offsets)
           
//        let requestTodelete = offsets.map { store.newsRequests[$0] }
//
//            store.deleteNewsRequest(requestNotificationID: requestTodelete[0].notificationID){ result in
//                switch result {
//                case .success:
//                    store.newsRequests.remove(atOffsets: offsets)
//
//                case .failure:
//                    print("")
//                  //  showFailedAlert.toggle()
//                }
//            }
            
        
    }
}


struct categorieRow: View {
    var categorie : ConsumableCategorie?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var store: AdminDataStore
    var body: some View {
        
        
         ZStack{
            
             if let consumableSection = categorie{
                 HStack(alignment: .center, spacing: 10) {

                     if horizontalSizeClass == .compact {
                         Image(consumableSection.image)
                             .resizable()
                             .foregroundColor(Color(hexString: consumableSection.iconColor))
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 50, height: 50)
                             .padding()
                             .background(Color(hexString: consumableSection.color))
                             .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                             
                     } else {
                       
                         Image(consumableSection.image)
                             .resizable()
                             .foregroundColor(Color(hexString: consumableSection.iconColor))
                             .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                             .padding()
                             .background(Color(hexString: consumableSection.color))
                             
                             .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                     }
                      
                    VStack(alignment: .leading, spacing: 8.0) {
                        
                        Text(consumableSection.title)
                            .font(.system(size: 20, weight: .bold))
                        Text(consumableSection.subtitle)
                            .font(.subheadline)
                            .lineLimit(2)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                     
                    }
                         

         
             }
             }
            
         

         }
        
    }
}
