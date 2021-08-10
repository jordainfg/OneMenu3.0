//
//  ConsumableListView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 27/01/2021.
//

import SwiftUI
import SDWebImageSwiftUI


enum menuState {
    case didApear
    case isLoading
    case addNewData
    case noDataAvailable
    case categoriesAndConsumablesAvailable
    case dataAvailableButStillLoadingImages
    case tryagain
    
}

enum ConsumableMenuOverviewActiveSheet: Identifiable {
    case addCategorieSheet, editCategorieSheet, showAddDRCategorieSheet, showEditDRCategorieSheet, showEditConsumable,showSubScriptionView,
         showAddConsumable,showAddPopularConsumable
    
    var id: Int {
        hashValue
    }
}

struct ConsumableMenuOverview: View {
    @State var collectionName : collectionName = .Meals
    @State var languageType : languageType = .Dutch
    
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    @State var activeSheet: ConsumableMenuOverviewActiveSheet?
    
    @State var showAddFirstCategorie = false
    
    @State var selectedConsumable: Consumable?
    @State var selectedConsumableCategorie: ConsumableCategorie?
    
    @State var reLoadAllMeals = false
    
    @ObservedObject var store: AdminDataStore
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var  menuState : menuState = .isLoading
    let screen = UIScreen.main.bounds
    @State var image :WebImage?
    
    @State var imagess : [String : WebImage] = [String: WebImage]()
    
    @State  var tryAgainCount = 0
    
    @State  var didTryAgain = false
    
    var columss = Array(repeating: GridItem(.adaptive(minimum: 100,maximum: 130), spacing: 20), count: 4)
    
    @State var consumables : [Consumable] = []
    
    var body: some View {
        switch menuState{
        case .isLoading:
            loading.onAppear{
                store.languageType = languageType
                store.collectionName = collectionName // is Meal or Beverage
                getData()
            }.smoothTransition()
        case .addNewData:
            content.smoothTransition()
        case .noDataAvailable:
            noDataAvailable.smoothTransition()
        case .categoriesAndConsumablesAvailable:
            content.smoothTransition()
        default:
            loading.smoothTransition()
        }
    }
    
    var content: some View {
        
        ScrollView {
            
            // MARK: - Categories
            VStack{
                
                // MARK: - All Categories
                HeaderForSection(text: languageType.categorieOneGroupHeader.uppercased())
                
                VStack {
                    LazyVGrid(
                        columns: columss,
                        spacing: 20
                    ) {
                        
                        addCategorieIcon() {
                            if isPremiumUser || consumables.count < 2{
                                activeSheet = .addCategorieSheet
                            } else {
                                HapticService.shared.standard(type: .warning)
                                activeSheet = .showSubScriptionView
                            }
                        }
                        
                        ForEach(store.consumableCategories.filter{$0.consumableSectionGroup == 0}, id: \.self ) { item in
                            
                            ConsumableCategorieIcon(consumableSection: item) {
                                
                                store.selectedConsumableCategorie = item
                                activeSheet = .editCategorieSheet
                            }
                        }
                    }
                    
                }
                .padding()
                .smoothTransition()
                .fullScreenCover(item: $activeSheet, onDismiss:{ activeSheet = nil },content: { item in
                    switch item {
                    
                    case .showAddPopularConsumable:
                        NavigationView{
                            CreateConsumableView(showPopularToggle: false, consumables: $consumables, isPopular : true, store: store, imagess: $imagess).navigationBarItems(trailing: closeButtonNavBarItem{activeSheet = nil})
                        }
                    case .showAddConsumable:
                        NavigationView{
                            CreateConsumableView(showPopularToggle: true, consumables: $consumables, isPopular : false, store: store, imagess: $imagess).navigationBarItems(trailing: closeButtonNavBarItem{activeSheet = nil})
                        }
                    case .addCategorieSheet:
                        CreateConsumableCategorieView(showRestrictToggle : false, store: store)
                    case .editCategorieSheet:
                        ManageConsumablesForCategorieView(collectionName: $collectionName, store: store, selectedCategorie: store.selectedConsumableCategorie,consumables: $consumables, imagess: $imagess)
                    case .showAddDRCategorieSheet:
                        CreateConsumableCategorieView(showRestrictToggle : false,consumableSectionGroup: 1, store: store)
                    case .showEditDRCategorieSheet:
                        ManageConsumablesForCategorieView(collectionName: $collectionName, store: store, selectedCategorie: store.selectedConsumableCategorie,consumables: $consumables, imagess: $imagess)
                    case .showEditConsumable:
                        EditConsumableView(showPopularToggle: false,consumables: $consumables, selectedConsumable: store.selectedConsumable, isPopular : false, store: store, imagess: $imagess)
                    case .showSubScriptionView:
                        SubscriptionView()
                    }
                })
                
                // MARK: - Dietary Restrictions Categories
                HeaderForSection(text: languageType.categorieTwoGroupHeader.uppercased())
                VStack {
                    LazyVGrid(
                        columns: columss,
                        spacing: 20
                    ) {
                        addCategorieIcon(){
                            if isPremiumUser || consumables.count < 2{
                                //HapticService.shared.complexSuccess()
                                activeSheet = .showAddDRCategorieSheet
                            } else {
                                HapticService.shared.standard(type: .warning)
                                activeSheet = .showSubScriptionView
                            }
                        }
                        
                        ForEach(store.consumableCategories.filter{$0.consumableSectionGroup == 1} , id: \.self ) { item in
                            ConsumableCategorieIcon(consumableSection: item) {
                                
                                store.selectedConsumableCategorie = item
                                activeSheet = .showEditDRCategorieSheet
                            }
                            
                        }
                    }
                }
                .padding()
                .smoothTransition()
                
                
            }
            
            if !store.consumableCategories.isEmpty{
                VStack{
                    
                    // MARK: - Popular Consumables
                    HeaderForSection(text: "bestsellers".uppercased())
                    VStack{
                        Spacer()
                        
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: horizontalSizeClass == .compact ? 120 : 190, maximum: 200), spacing: 20)],
                            spacing: 20
                        ) {
                            AddSpecialConsumableCardButton(){
                                if isPremiumUser || consumables.count < 2{
                                    activeSheet = .showAddPopularConsumable
                                   
                                } else {
                                    HapticService.shared.standard(type: .warning)
                                    activeSheet = .showSubScriptionView
                                }
                            }
                            
                            ForEach(consumables.filter {$0.isPopular == true}, id: \.self ) { item in
                                if !consumables.isEmpty {
                                    
                                    NavigationLink(destination: EditConsumableView(showPopularToggle: false,consumables: $consumables, selectedConsumable: item, isPopular : false, store: store, imagess: $imagess)){
                                        SpecialConsumableCard(consumable:item, image : imagess[item.consumableID]).tag(item.id)
                                    }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                                }
                                
                            }.animation(.easeInOut)
                            
                        }
                        .padding(20)
                    }
                    
                    // MARK: - All Consumables
                    HeaderForSection(text: languageType.allConsumablesHeader.uppercased())
                    HStack {
                        AddNewConsumableRow(){
                            if isPremiumUser || consumables.count < 2{
                                activeSheet = .showAddConsumable
                              
                            } else {
                                HapticService.shared.standard(type: .warning)
                                activeSheet = .showSubScriptionView
                            }
                        }
                        Spacer()
                    }.padding(.horizontal).padding(.top,10)
                    
                    ForEach(consumables, id: \.self ) { item in
                        
                        NavigationLink(destination: EditConsumableView(showPopularToggle: false,consumables: $consumables, selectedConsumable: item, isPopular : false, store: store, imagess: $imagess)){
                            ConsumableRow(item: item, image : imagess[item.consumableID]).buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top,10)
                    
                }.smoothTransition()
            }
        }
        .navigationTitle("Manage")
        
    }
    
    var addNewData : some View{
        VStack(spacing: 25 ){
            Spacer()
            Text("Get started").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            addCategorieIcon(){
                showAddFirstCategorie = true
         
            }
            .fullScreenCover(isPresented: $showAddFirstCategorie, onDismiss:{
                menuState = .isLoading
            }, content: {
                CreateConsumableCategorieView(showRestrictToggle : false, store: store)
            })
            Spacer()
        }
        .padding(.horizontal,20)
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
    
    var loading : some View{
        CustomProgressView(showText: true)
    }
    
    // MARK: - Funtions
    func getConsumableCategories(completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        store.getConsumableCategories(collectionName: collectionName == .Meals ? .MealCategories : .BeveragesCategories, languageType:languageType){ result in
            switch result {
            case let .success(response):
                
                completionHandler(.success(response))
            case .failure:
                menuState = .tryagain
                completionHandler(.failure(CoreError.errorDescription(error: "Failed to get consumable categories")))
            }
        }
    }
    
    func getConsumables(){
        store.getConsumables(collectionName: collectionName == .Meals ? .Meals : .Beverages, languageType: languageType, forRestaurant: store.selectedRestaurant?.restaurantID ?? "") { result in
            switch result {
            case .success:
                
                menuState = .dataAvailableButStillLoadingImages
                consumables = store.consumables
                
                let myDispatchGroup = DispatchGroup()
                
                
                for consumable in consumables {
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
                    
                    menuState = .categoriesAndConsumablesAvailable
                    
                    HapticService.shared.complexSuccess()
                    
                    
                }
                
                print("FETCHING IMAGES FOR Consumables")
            case .failure:
                menuState = .tryagain
                print("Fail")
                
            }
        }
    }
    
    func getData(){
        
        getConsumableCategories(){ result in
            switch result {
            case let .success(response):
                if response == .collectionRetrievedButIsEmpty{
                    menuState = .addNewData
                } else {
                    getConsumables()
                }
                
            case .failure:
                if didTryAgain {
                    print("Retry failed")
                    menuState = .noDataAvailable
                } else {
                    getData()
                    didTryAgain = true
                    print("retrying")
                }
            }
        }
        
        
    }
    
}

extension View {
    func smoothTransition() -> some View{
        self.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
    }
}
