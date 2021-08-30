//
//  HomeForSelectedRestaurant.swift
//  HomeForSelectedRestaurant
//
//  Created by Jordain on 23/08/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct TabViewForRestaurant: View {
    
    @State var selectedRestaurant : Restaurant?

    //Init firebase integration
    // MARK: - Variable's
    @State var collectionName : collectionName = .Meals
    
    @State var languageType : languageType = .Dutch
    
    @ObservedObject var store : DataStore
    
    @State var  viewState : viewState = .isLoading
    
    let screen = UIScreen.main.bounds
    
    @State var imagess : [String : WebImage] = [String: WebImage]()
    
    @State  var didTryAgain = false // used to retry fetching data 
    
    // MARK: - Functions
    func getConsumableCategories(completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        store.getConsumableCategories(collectionName: collectionName == .Meals ? .MealCategories : .BeveragesCategories, languageType:languageType){ result in
            switch result {
            case .success:
                completionHandler(.success(Response.collectionRetrieved))
            case .failure:
                viewState = .tryagain
                completionHandler(.failure(CoreError.errorDescription(error: "Failed to get consumable categories")))
            }
        }
    }
    
    func getConsumables(){
        store.getConsumables(collectionName: collectionName == .Meals ? .Meals : .Beverages, languageType: languageType) { result in
            switch result {
            case .success:
                
                viewState = .dataAvailableButStillLoadingImages
                
               
                let myDispatchGroup = DispatchGroup()
                
                
                for consumable in store.consumables {
                    myDispatchGroup.enter()
                    var url = consumable.image
                    if !url.hasPrefix("gs://") {
                        url = "gs://one-menu-40f52.appspot.com/Assets/placeHolderForOneMenuDark@3x.png"
                    }
                    let storageRef = store.storage.reference(forURL: url)
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                            self.imagess[consumable.consumableID] = WebImage(url: URL(string:""))
                            myDispatchGroup.leave()
                        } else {
                            if let url = url {
                                self.imagess[consumable.consumableID] = WebImage(url: url)
                                print("Got image for consumable : \(consumable.consumableID)")
                                myDispatchGroup.leave()
                                
                            }
                        }
                        
                    }
                    
                    
                }
                
                myDispatchGroup.notify(queue: .main) {
                    print("FINISHED fetching all images")
                   
                        viewState = .dataAvailable
                        store.needsToLoadConsumables = false
                    HapticService.shared.complexSuccess()
                }
                
                print("FETCHING IMAGES FOR MEALS")
            case .failure:
                viewState = .tryagain
                print("Fail")
                
            }
        }
    }
    
    func getData(){
        // TODO - Make it load only once to avoid high firbase bill
        //if store.needsToLoadConsumables {
            getConsumableCategories(){ result in
                switch result {
                case .success:
                    if store.consumableCategories.isEmpty{
                        viewState = .noDataAvailable
                    } else {
                    getConsumables()
                    }
                case .failure:
                    if didTryAgain {
                        print("Retry failed")
                        viewState = .noDataAvailable
                    } else {
                        getData()
                        didTryAgain = true
                        print("retrying")
                    }
                }
            }
            
        //}
    }
    
    var body: some View {
        
        switch viewState{
        case .isLoading:
            loading.onAppear{
                store.languageType = languageType
                store.collectionName = collectionName
                store.selectedRestaurant = selectedRestaurant
                getData()
            }
        case .noDataAvailable:
            noDataAvailable
        case .dataAvailable:
            content.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.6)))
        default:
            loading
        }
    }
    
    var loading : some View {
        VStack{
            if #available(iOS 14, *) {
                ProgressView()
            } else {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            }
        }.frame(maxWidth:.infinity)
        .frame(height: 50)
    }
    
    var noDataAvailable : some View{
        VStack(spacing: 25 ){
            Image(systemName: "cloud")
                .renderingMode(.template)
                .font(.system(size: 80))
                .foregroundColor(.primary)
            VStack(spacing: 10 ){
                Text("failedTitle").font(.headline).fontWeight(.semibold).multilineTextAlignment(.center).lineLimit(10)
                Text("failedsubTitle").font(.subheadline).fontWeight(.regular).lineLimit(10).multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal,20)
    }
    
    
    //end firebase integration
    
    var content: some View {
        TabView {
            RestaurantHomeView(restaurant: selectedRestaurant!, store: store)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }.navigationBarTitleDisplayMode(.inline)
            
            BrowseMenuView(imagess: imagess, store: store)
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }.navigationBarTitleDisplayMode(.inline)
            
            FavoritesView(store: store,imagess: imagess)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }.navigationBarTitleDisplayMode(.inline)
            
            BookingsView()
                .tabItem {
                    Label("Bookings", systemImage: "calendar")
                }.navigationBarTitleDisplayMode(.inline)
            
            BasketView(imagess: imagess,store: store)
                .tabItem {
                    Label("Basket", systemImage: "bag")
                }.navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(selectedRestaurant?.name ?? "")
    }
}

struct HomeForSelectedRestaurant_Previews: PreviewProvider {
    static var previews: some View {
        TabViewForRestaurant(selectedRestaurant: Restaurant.default,store: DataStore())
    }
}
