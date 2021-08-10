//
//  CategoriesListView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 26/01/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct ListOfConsumablesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var imagess : [String : WebImage]
    
    @State private var searchText = ""
    
    
    @ObservedObject var store: AdminDataStore
    
    @State var presentCreateConsumables : Bool = false
    
    @State var  viewState : viewState = .isLoading
    @State var createSumButtonPressed = false
    
    @State var language : languageType = .Dutch
    func getConsumables(){
        viewState = .isLoading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            viewState = .dataAvailable
        })
//        store.getConsumableCategories(language: language){ result in
//            switch result {
//            case .success:
//                viewState = .dataAvailable
//            case .failure:
//                viewState = .noDataAvailable
//                print("Fail")
//            }
//        }
        
    }
    
    var body: some View {
        ZStack{
            switch viewState{
            
            case .isLoading:
                loading.onAppear{
                    
                    getConsumables()
                    
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
                    getConsumables()
                    
                }
            default:
                loading
            }
        }.navigationBarTitle("Consumables",displayMode: .inline)
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
        NavigationView {
            List{
                
                if store.consumables.isEmpty{
                    HStack {
                        Spacer()
                        Text("No consumables yet").font(.footnote).foregroundColor(.secondary)
                        Spacer()
                    }
                }
                
                
                ForEach(store.consumables.filter { $0.title.contains(searchText) || searchText.isEmpty }, id: \.self ) { item in
                    ConsumableRow(item: item, image : imagess[item.consumableID])
                }
                
                .onDelete(perform: deleteRequestFromFirestore)
                .padding(.horizontal)
                .padding(.top,10)
                .smoothTransition()
                
            }
            .sheet(isPresented: $presentCreateConsumables, content: {
               // CreateConsumableView( imagess: $imagess)
            })
            .navigationBarTitle("Consumables")
            .listStyle(InsetGroupedListStyle())
            
            .navigationBarItems(leading:Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            ,trailing: Button(action: {
                presentCreateConsumables = true
            }) {
                Text("Add")
        })
        }
    }
    private func deleteRequestFromFirestore(at offsets: IndexSet) {
        
        store.consumables.remove(atOffsets: offsets)
        
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

