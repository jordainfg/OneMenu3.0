//
//  ConsumablesView.swift
//  DesignCodeCourse
//
//  Created by Jordain Gijsbertha on 30/07/2020.
//// Lazy Grid -> https://www.hackingwithswift.com/quick-start/swiftui/how-to-position-views-in-a-grid-using-lazyvgrid-and-lazyhgrid



/// ROOT VIEW
enum viewState {
    case isLoading
    case noDataAvailable
    case dataAvailable
    case dataAvailableButStillLoadingImages
    case tryagain
}

import SwiftUI
import SDWebImageSwiftUI

struct MainViewForConsumables: View {

    // MARK: - Variable's
    @State var collectionName : collectionName = .Meals
    @State var languageType : languageType = .Dutch
    
    @ObservedObject var store : DataStore
    
    //Search Bar
    @State var isSearching = false
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @State var selectedPopularConsumable : Int? = nil
    
    // *1 Detects if the device is an ipad or iphone
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    // *
    
    @State var showTutorial = false
    
    @State var  viewState : viewState = .isLoading
    let screen = UIScreen.main.bounds
    @State var image :WebImage?
    
    @State var imagess : [String : WebImage] = [String: WebImage]()
    
    
    @State  var didTryAgain = false
    
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
    
    
    var loading : some View{
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
    
    
    var content: some View {
        
        ScrollView {

                VStack(alignment: .center, spacing: 0)  {
                    if !isSearching{
                        VStack{
                            // MARK: - All Categories
                            if let consumableSelectionGroupOne = store.consumableCategories.filter{$0.consumableSectionGroup == 0} {
                                if !consumableSelectionGroupOne.isEmpty {
                                    HeaderForSection(text: languageType.categorieOneGroupHeader.uppercased())
                                            VStack {
                                                LazyVGrid(
                                                    columns: [GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20),GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20),GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20),GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20)],
                                                    spacing: 20
                                                ) {
                                                    
                                                    ForEach(consumableSelectionGroupOne, id: \.self ) { item in
                                                        NavigationLink(destination: ConsumablesForSelectedCategorie(selectedCategorie: item, store: store, imagess:imagess )) {
                                                            ConsumableCategorieIcon(consumableSection: item)
                                                        }
                                                    }
                                                }
                                                
                                            }
                                            .padding()
                                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.9)))
//                                        } else {
//                                            ScrollView(.horizontal, showsIndicators: false) {
//                                                HStack(spacing: 20) {
//                                                    ForEach(consumableSelectionGroupOne) { item in
//                                                        NavigationLink(destination: ConsumablesForSelectedCategorie(selectedCategorie: item, store: store, imagess:imagess )) {
//                                                            ConsumableCategorieIcon(consumableSection: item)
//                                                        }
//                                                    }
//
//                                                    .frame(maxWidth: .infinity)
//                                                }.padding(.horizontal)
//                                            }.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.9)))
//
//                                        }
                                    
                                }
                            }
                            
                            // MARK: - Dietary Restrictions Categories
                            if let consumableSelectionGroupTwo = store.consumableCategories.filter{$0.consumableSectionGroup == 1} {
                                if !consumableSelectionGroupTwo.isEmpty {
                                    HeaderForSection(text: languageType.categorieTwoGroupHeader.uppercased())
                                            VStack {
                                                LazyVGrid(
                                                    columns: [GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20),GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20),GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20),GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20)],
                                                    spacing: 20
                                                ) {
                                                    ForEach(consumableSelectionGroupTwo, id: \.self ) { item in
                                                        NavigationLink(destination: ConsumablesForSelectedCategorie(selectedCategorie: item, store: store, imagess:imagess )) {
                                                            ConsumableCategorieIcon(consumableSection: item)
                                                        }
                                                    }
                                                }
                                            }
                                            .padding()
                                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.9)))
                                        
                                        
                                }
                            }
                            
                            // MARK: - Popular Consumables
                            if let bestSellers = store.consumables.filter {$0.isPopular == true}{
                                if !bestSellers.isEmpty {
                                HeaderForSection(text: "Bestsellers".uppercased())
                                   
                                            VStack{
                                                Spacer()
                                                
                                                LazyVGrid(
                                                    columns: [GridItem(.adaptive(minimum: horizontalSizeClass == .compact ? 120 : 190, maximum: 200), spacing: 20)],
                                                    spacing: 20
                                                ) {
                                                    ForEach(bestSellers, id: \.self ) { item in
                                                        ZStack{
                                                            if !store.consumables.isEmpty {
                                                                NavigationLink(destination: ConsumableForSelectionDetail(show: false, consumable: item, image : imagess[item.consumableID]), tag: store.consumables.firstIndex(of: item)!, selection: self.$selectedPopularConsumable) {
                                                                    SpecialConsumableCard(consumable:item, image : imagess[item.consumableID]).tag(item.id)
                                                                    
                                                                }.disabled(true)
                                                                VStack{}.frame(maxWidth: 200, maxHeight: .infinity)
                                                                    .background(Color.black.opacity(0.000001))
                                                                    .onTapGesture{
                                                                        self.selectedPopularConsumable = store.consumables.firstIndex(of: item)!
                                                                    }
                                                            }
                                                        }
                                                        
                                                    }.animation(.easeInOut)
                                                }
                                                .padding(20)
                                            }
                                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.9)))
                                        
                                }
                            }
                            
                            
                        }
                        
                    }
                    // MARK: - All Consumables
                    if let allConsumables = store.consumables{
                        if !allConsumables.isEmpty {
                            if !isSearching{
                                HeaderForSection(text: languageType.allConsumablesHeader)
                            }
                                ForEach(store.consumables.filter { $0.title.contains(searchText) || searchText.isEmpty }, id: \.self ) { item in
                                    NavigationLink(destination: ConsumableForSelectionDetail(isFromSearchView: isSearching ? true : false , show: false, consumable: item, image : imagess[item.consumableID])) {
                                        ConsumableRow(item: item, image : imagess[item.consumableID])
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top,10)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.9)))
                            
                        }
                    
                }
                }.navigationBarTitle(collectionName == .Meals ? "Meals" : "Beverages")
        }
    }
    
}
