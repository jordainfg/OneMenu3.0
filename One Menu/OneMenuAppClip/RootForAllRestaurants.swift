//
//  RootForAllRestaurants.swift
//  OneMenuAppClip
//
//  Created by Jordain Gijsbertha on 23/03/2021.
//

import SwiftUI
import StoreKit
struct RootForAllRestaurants: View {
    @State var  viewState : viewState = .isLoading
    @StateObject var store = DataStore()
    @State var restaurants : [Restaurant] = []
    @State private var presentingAppStoreOverlay = false
    @EnvironmentObject var appClipState: AppClipsState
    func getRestaurants(){
        viewState = .isLoading
        store.getRestaurants { result in
            switch result {
            case .success:
                withAnimation(.easeIn(duration: 0.6), {
                    restaurants = store.restaurants.filter{$0.isEditing == false}
                    viewState = .dataAvailable
                })
                
            case .failure:
                FirebaseService.shared.refreshToken { result in
                    switch result {
                    case .success:
                        getRestaurants()
                    case .failure:
                        viewState = .noDataAvailable
                    }
                }
                
            }
            
        }
        
        //        store.getRestaurants{ result in
        //            switch result {
        //            case .success:
        //
        //                print("Success retrieving all restaurants")
        //
        //                viewState = .dataAvailable
        //
        //            case .failure:
        //                viewState = .noDataAvailable
        //                print("Fail")
        //
        //            }
        //        }
    }
    
    var body: some View {
        
        ZStack{
            switch viewState{
            
            case .isLoading:
                loading.onAppear{
                    getRestaurants()
                }
                .smoothTransition()
            case .dataAvailable:
                
                content.smoothTransition()
                
            case .noDataAvailable:
                Button(action: {
                    getRestaurants()
                }) {
                    VStack(spacing:10){
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .renderingMode(.template)
                            .font(.largeTitle)
                            .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                        
                        Text(LocalizedStringKey("tryagain"))
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                    }
                }
                .smoothTransition()
                .padding(.top)
                .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
            default:
                loading
            }
        }
    }
    var content: some View {
        NavigationView {
            FilteringList(restaurants, filterKeys: \.name, \.address) { restaurant in
                NavigationLink(destination: RootForScannedRestaurant(store: store, selectedRestaurant: restaurant).environmentObject(appClipState), label: {
                    RestaurantRow(item: restaurant)
                })
                
            }
            .navigationBarTitle("One Menu")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentingAppStoreOverlay = true
                                    }, label: {
                                        HStack{
                                            Spacer()
                                            Image(systemName: "arrow.down.app").font(.system(size: 22))
                                        }
                                        .frame(width: 70,height: 40)
                                        .appStoreOverlay(isPresented: $presentingAppStoreOverlay) {
                                            SKOverlay.AppClipConfiguration(position: .bottom)
                                        }
                                    }).foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                            presentingAppStoreOverlay = true
                                        })
                                    }
            )
        }
    }
    var loading : some View{
        VStack{
            CustomProgressView(showText: true)
            
        }.frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
}




struct FilteringList<T:Identifiable, Content:View> : View{
    
    @State private var searchedItems = [T]()
    @State private var searchText = ""
    
    let searchableItems : [T] // Users,Meals,Beverages etc.
    let filterKeyPaths: [KeyPath<T,String>] // properties of a searchable item: for example for user it can be name.
    
    let content : (T) -> Content
    
    var body: some View{
        VStack(spacing:0) {
            // CustomSearchBar(text: $searchText.onChange(applyFilter))
            
            List(searchedItems, rowContent: content)
                .listStyle(InsetGroupedListStyle())
                .onAppear(perform: applyFilter)
        }
        .navigationBarSearch($searchText.onChange(applyFilter))
    }
    
    /// Example with users UserForList(name: "Jordain", company: "Apple", email: "jord=@gmail.com", phone: "0638482214", address: "Joonchi")
    /// - Parameters:
    ///   - data: Users,Meals,Beverages etc.
    ///   - filterKeys: Properties of data: for example for user it can be name.
    ///   - rowContent: VStack {  Text(user.name).font(.headline)  }
    init(_ data: [T], filterKeys: KeyPath<T, String>..., @ViewBuilder rowContent: @escaping (T) -> Content) {
        searchableItems = data
        filterKeyPaths = filterKeys
        content = rowContent
    }
    
    func applyFilter() {
        let cleanedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedSearchText.isEmpty {
            searchedItems = searchableItems
        } else {
            searchedItems = searchableItems.filter { element in
                filterKeyPaths.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(cleanedSearchText)
                }
            }
        }
    }
}
extension View {
    func smoothTransition() -> some View{
        self.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.6)))
    }
}
extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}


