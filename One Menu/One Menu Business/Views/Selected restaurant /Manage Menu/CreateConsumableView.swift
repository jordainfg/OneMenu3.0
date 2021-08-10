//
//  CreateConsumableView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 27/01/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct CreateConsumableView: View {
    @Environment(\.presentationMode) var presentationMode
    @State  var showPopularToggle = false
    @State  var isLoading = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var consumables : [Consumable]
    @State private var isEditingPrice = false
    @State private var showColors = false

    @State var alerts: alerts? = nil
    @State var erroDiscription: String = ""
    
    @State var forRestaurantID: String = ""
    @State var isDutch: Bool = false

    @State var headline: String = ""
    @State var colors: [String] = ["#FA565F","#FB0944","#177EBD","#76C53B","#18DE6C","#FD9513","#9C41D0","#FA2840"]
    @State var colorTone: String = "#FA565F"
    @State var imageURL: String = "gs://one-menu-40f52.appspot.com/Assets/placeholder-image.png"
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var calories: String = ""
    @State var price: String = ""
    @State var currency: String = ""
    @State var carbs: String = ""
    @State var carbsPercentage: String = ""
    @State var fat: String = ""
    @State var fatPercentage: String = ""
    @State var protein: String = ""
    @State var proteinPercentage: String = ""
    
    
    @State var allergen: String = ""
    @State var allergens: [String]  = []
    
    @State var option: String = ""
    @State var options: [String]  = []
    
    @State var extra: String = ""
    @State var extras: [String] = []
    
    @State var hasExtras: Bool = false
    @State var hasOptions: Bool = false
    @State var hasNutrition: Bool = false
    @State var hasIngredients: Bool = false
    @State var isPopular: Bool = false
    
    @State private var image : Image?
    
    @State private var showingImagePicker = false
    
    @State private var inputImage: UIImage?
    
    @ObservedObject var store: AdminDataStore
    
    @Binding var imagess : [String : WebImage]
    
    var requiredFieldsAreFilled : Bool {
        if headline.isEmpty || title.isEmpty || subtitle.isEmpty || calories.isEmpty || price.isEmpty || currency.isEmpty{
            return false
        } else {
            return true
        }
    }
    func deleteAllergens(at offsets: IndexSet) {
        allergens.remove(atOffsets: offsets)
    }
    func deleteOptions(at offsets: IndexSet) {
        options.remove(atOffsets: offsets)
    }
    
    func deleteExtras(at offsets: IndexSet) {
        extras.remove(atOffsets: offsets)
    }
    var body: some View {
        if isLoading{
                    CustomProgressView().smoothTransition()
        } else {
            Form {
                
                if showPopularToggle {
                VStack {
                    Toggle(isOn: $isPopular) {
                        Text("Show in bestsellers section").font(.footnote)
                    }
                }
                }
                
                Section(header: Text("Required fields").foregroundColor(requiredFieldsAreFilled ? .red : .secondary)) {
                    
                    HStack{
                        Text("Headline:").font(.subheadline).foregroundColor(.secondary)
                        Spacer()
                        TextField("Popular choice", text: $headline)
                    }
                    Button(action: {
                        // your action here
                        withAnimation{
                            showColors.toggle()
                        }
                    }) {
                        
                        HStack{
                            Text("Color tone").font(.subheadline).foregroundColor(.secondary)
                            Spacer()
                            RoundedRectangle(cornerRadius: 3, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(hexString: colorTone))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.primary, lineWidth: 0.2)
                                )
                            
                            
                        }.background(Color.white.opacity(0.00001))
                    }
                    
                    if showColors{
                        
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 30,maximum: 30), spacing: 20)],
                            spacing: 20
                        ) {
                            ForEach(colors, id: \.self) { color in
                                Button(action: {
                                    withAnimation{
                                        colorTone = color
                                        showColors.toggle()
                                    }
                                }) {
                                    RoundedRectangle(cornerRadius: 3, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                        .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(Color(hexString: color))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color.primary, lineWidth: 0.2)
                                        )
                                }
                                .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                                
                            }
                        }.padding(10)
                    }
                    
                    textFieldWithDoneButton(name: "Title", placeHolder: "Watermelon & mint blast", text: $title,trailingText: "", keyBoardType: .default)
                
                    textFieldWithDoneButton(name: "Subtitle", placeHolder: "A Watermelon Smoothie recipe with lime and mint.", text: $subtitle,trailingText: "", keyBoardType: .default)
                    
                    textFieldWithDoneButton(name: "Calories", placeHolder: "2000", text: $calories,trailingText: "kcal", keyBoardType: .numberPad)
                   
                    textFieldWithDoneButton(name: "Price", placeHolder: "12,99", text: $price, keyBoardType: .decimalPad)
                    
                    textFieldWithDoneButton(name: "Currency", placeHolder: "$,€,¥,£", text: $currency, keyBoardType: .default)
                       
                }
                
                
                Section(header: Text("Header image")) {
                    if  image != nil{
                        
                        image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth:.infinity)
                            .overlay(VStack{
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        withAnimation{
                                        imageURL = "gs://one-menu-40f52.appspot.com/Assets/placeholder-image.png"
                                                                            image = nil
                                                                            inputImage = nil
                                        }
                                    }) {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "xmark.circle.fill")
                                                .renderingMode(.template)
                                                .font(.title)
                                                .foregroundColor(.white)
                                        }.padding(15)
                                    }
                                }
                                Spacer()
                            }
                            .frame(maxWidth:.infinity,maxHeight: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .topTrailing, endPoint: .bottom).opacity(0.4))
                            )
                    }
                    
                    if  image == nil{
                        HStack{
                            Spacer()
                            Button(action: {
                        
                                sourceType = .photoLibrary
                                if requiredFieldsAreFilled{
                                    showingImagePicker.toggle()
                                } else {
                                    alerts = .showValidationAlert
                                }
                            }) {
                                VStack(spacing:10){
                                    Image(systemName: "photo")
                                        .renderingMode(.template)
                                        .font(.largeTitle)
                                        .foregroundColor(requiredFieldsAreFilled ? Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)): Color.secondary)
                                    Text("Choose").font(.footnote).foregroundColor(.secondary).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    
                                }.padding(30)
                            }
                            .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                ImagePicker(sourceType: sourceType, image: self.$inputImage)
                            }
                            
                            
                            Spacer()
                            
                            Button(action: {
                                
                                sourceType = .camera
                                if requiredFieldsAreFilled{
                                    showingImagePicker.toggle()
                                } else {
                                    alerts = .showValidationAlert
                                }
                            }) {
                                VStack(spacing:10){
                                    Image(systemName: "camera.fill")
                                        .renderingMode(.template)
                                        .font(.largeTitle)
                                        .foregroundColor(requiredFieldsAreFilled ? Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)): Color.secondary)
                                    Text("Take").font(.footnote).foregroundColor(.secondary).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    
                                }.padding(30)
                            }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                            
                            Spacer()
                        }
                    }
                    
                }.listRowInsets(EdgeInsets())
                
                
                Section(header: Text("Nutrition Data")) {
                    Toggle(isOn: $hasNutrition.animation()) {
                        Text("Shows nutrition data").font(.footnote)
                    }
                    if hasNutrition{
                        
                        textFieldWithDoneButton(name: "Carbs", placeHolder: "33", text: $carbs,trailingText: "gr", keyBoardType: .numberPad)
                        
                        textFieldWithDoneButton(name: "Carbs percentage", placeHolder: "25", text: $carbsPercentage, trailingText: "%", keyBoardType: .numberPad)
                       
                        textFieldWithDoneButton(name: "Fat", placeHolder: "33", text: $fat, trailingText: "gr", keyBoardType: .numberPad)
                        
                        textFieldWithDoneButton(name: "Fat percentage", placeHolder: "25", text: $fatPercentage, trailingText: "%", keyBoardType: .numberPad)
                        
                        textFieldWithDoneButton(name: "Protein", placeHolder: "33", text: $protein, trailingText: "gr", keyBoardType: .numberPad)
                        
                        textFieldWithDoneButton(name: "Protein percentage", placeHolder: "25", text: $proteinPercentage, trailingText: "%", keyBoardType: .numberPad)
                            
                    }
                }
                
                // MARK: - Ingredients
                Section(header: Text("Ingredients")) {
                    Toggle(isOn: $hasIngredients.animation()) {
                        Text("Show ingredients").font(.footnote)
                    }
                    if hasIngredients{
                        HStack{
                            TextField("Milk", text: $allergen)
                            Spacer()
                            if allergen.count > 2 {
                            Button(action:{allergens.append(allergen)
                                    allergen = ""
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}){
                                Text("Add").fontWeight(.semibold).font(.body)
                                    .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                            }
                            }
                        }
                        ForEach(allergens, id: \.self){ allergen in
                            HStack {
                                Text("Ingredient").font(.footnote).foregroundColor(.secondary).fontWeight(.semibold)
                                Spacer()
                                Text(allergen).foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                            }
                        }.onDelete(perform: deleteAllergens)
                    }
                    
                }
                
                // MARK: - Options
                Section(header: Text("Options")) {
                    Toggle(isOn: $hasOptions.animation()) {
                        Text("Shows options").font(.footnote)
                    }
                    if hasOptions{
                        HStack{
                            TextField("White Rice", text: $option)
                            Spacer()
                            if option.count > 2 {
                            Button(action:{options.append(option)
                                option = ""
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }){
                                Text("Add").fontWeight(.semibold).font(.body)
                                    .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                            }
                            }
                        }
                        
                        ForEach(options, id: \.self){ option in
                            
                            HStack {
                                Text("Option").font(.footnote).foregroundColor(.secondary).fontWeight(.semibold)
                                Spacer()
                                Text(option).foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                            }
                            
                        }.onDelete(perform: deleteOptions)
                    }
                    
                }
                
                
                // MARK: - EXTRA'S
                Section(header: Text("EXTRA'S")) {
                    Toggle(isOn: $hasExtras.animation()) {
                        Text("Shows extra's").font(.footnote)
                    }
                    if hasExtras{
                        HStack{
                            TextField("Avocado", text: $extra)
                            Spacer()
                            if extra.count > 2 {
                            Button(action:{extras.append(extra)
                                extra = ""
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }){
                                Text("Add").fontWeight(.semibold).font(.body)
                                    .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                            }
                            }
                        }
                        ForEach(extras, id: \.self) { extra in
                            HStack {
                                Text("Extra").font(.footnote).foregroundColor(.secondary).fontWeight(.semibold)
                                Spacer()
                                Text(extra).foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                            }
                        }
                        .onDelete(perform: deleteExtras)
                    }
                }
                
          
                
            }
            .padding(.bottom,40)
            .overlay(
                customToolBar(isVisable: true,showDeleteButton : false,firstButtonName: "Create" ,firstButtonAction: {
                if requiredFieldsAreFilled{
                    isLoading = true
                    
                    createConsumableWithImage()
                    
                } else {
                        alerts = .showValidationAlert
                    }
            }, deleteButtonAction: {})
                .alert(item: $alerts){ alert in
                    switch alert {
                    case .showSuccessAlert:
                        return Alert(title: Text("Success"), message: Text("Your meal has been successfuly created."), dismissButton: Alert.Button.default(
                            Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                       ))
                    
                    case .showFailedAlert:
                        return  Alert(title: Text("Whoops"), message: Text("We couldn't create your meal, please try again later."), dismissButton: Alert.Button.default(
                            Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                       ))
                    
                    case .showValidationAlert:
                        return   Alert(title: Text("Whoops"), message: Text("Please fill in all required fields first."), dismissButton: Alert.Button.default(
                            Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: {  }
                       ))
                    case .showSubscribeAlert:
                        return   Alert(title: Text("Whoops"), message: Text("Please fill in all required fields first."), dismissButton: Alert.Button.default(
                            Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                        ))
                     
                    }
                    
                }
            
            )
            .navigationBarTitle("Create",displayMode: .inline)
        }
        
        
    }
    
  
    func createConsumableWithImage(){
        if let restaurantID = store.selectedRestaurant?.name{
            if let imageData = inputImage?.jpegData(compressionQuality: 0.1){
                let folder = "/\(restaurantID)1/Consumables"
                
                store.uploadImage(imageID: "\(title)", imageData: imageData, folder: folder){ result in
                    switch result {
                    case let .success(url):
                        imageURL = url
                        createConsumable()
                    case .failure:
                        print("UPLOAD FAILED")
                        erroDiscription = "Failed to upload image, please try again."
                        alerts = .showFailedAlert
                        return
                    }
                }
            } else {
               
                createConsumable()
            }
        }
    }
    
    func createConsumable(){
        
        let newConsumableDict:[String:Any] = [    "consumableID" : "",
                                            "headline": headline,
                                            "colorTone": colorTone,
                                            "image": imageURL,
                                            "title": title,
                                            "subtitle": subtitle,
                                            "calories": "\(calories.prefix(6))",
                                            "price" : Double(price.replacingOccurrences(of: ",", with: ".")) ?? 0.00,
                                            "currency" : currency,
                                            "carbs" : carbs,
                                            "carbsPercentage" : Int(carbsPercentage.prefix(2)) ?? 0,
                                            "fat" : fat,
                                            "fatPercentage": Int(fatPercentage.prefix(2)) ?? 0,
                                            "protein": protein,
                                            "proteinPercentage": Int(proteinPercentage.prefix(2)) ?? 0,
                                            "extras": extras,
                                            "allergens": allergens,
                                            "options": options,
                                            "hasExtras": hasExtras,
                                            "hasOptions": hasOptions,
                                            "hasNutrition": hasNutrition,
                                            "hasIngredients": hasIngredients,
                                            "isPopular":isPopular]
        
        if let consumable = Consumable(dictionary: newConsumableDict){
            
            store.createConsumable(consumable: consumable){result in
                
                switch result {
                case let .success(createdConsumable):
                    let storageRef = store.storage.reference(forURL: createdConsumable.image)
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                            self.imagess[createdConsumable.consumableID] = WebImage(url: URL(string:""))
                            self.consumables.append(createdConsumable)
                            isLoading = false
                            alerts = .showSuccessAlert
                            
                        } else {
                            
                            if let url = url {
                                self.imagess[createdConsumable.consumableID] = WebImage(url: url)
                                print("Got image for consumable : \(consumable.consumableID)")
                                self.consumables.append(createdConsumable)
                            }
                            isLoading = false
                            alerts = .showSuccessAlert
                           
                        }
                    }
                case .failure(_):
                    isLoading = false
                    alerts = .showFailedAlert
                    print("Failed to create consumable. Please try again later.")
                    
                }
            }
        }
        
    }
    
    //A method that will be called when the ImagePicker view has been dismissed.
    func loadImage() {
        guard let inputImage = inputImage else { return }
        withAnimation{
            image = Image(uiImage: inputImage)
        }
    }
}


