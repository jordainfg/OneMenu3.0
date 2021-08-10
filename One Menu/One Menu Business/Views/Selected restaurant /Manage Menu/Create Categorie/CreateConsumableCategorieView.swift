//
//  CreateConsumableCategorieView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 26/01/2021.
//

import SwiftUI

struct CreateConsumableCategorieView: View {
    
    @State var showRestrictToggle : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var image: String = "icons8-avocado-50"
    @State var color: String = "#F2F2F7"
    @State var iconColor: String = "#1B426C"
    @State var consumablesByID: [String] = []
    @State var consumableSectionGroup : Int = 0

    
    @State var consumableCategorie : ConsumableCategorie?
    @State private var firstToggle = false
    
    @ObservedObject var store: AdminDataStore
    
    @State var isLoading : Bool = false
    
    @State var language : languageType = .Dutch
    
    var requiredFieldsAreFilled : Bool {
        if title.isEmpty || subtitle.isEmpty{
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        let firstBinding = Binding(
            get: { self.firstToggle },
            set: {
                self.firstToggle = $0
                
                if $0 == true {
                  consumableSectionGroup = 1
                } else {
                  consumableSectionGroup = 0
                }
            }
        )
        NavigationView {
            if isLoading{
                        CustomProgressView().smoothTransition()
            } else {
            List{
                Section(header: Text("About"), footer:Text(!requiredFieldsAreFilled ? "Name and description are required." : "").foregroundColor(.red).fontWeight(.bold)){
                    TextField("Categorie name", text: $title)
                    TextField("Categorie description", text: $subtitle)
                    
                }
                
                Section(header: Text("Design")){
                    categorieCreatorRow(title: $title, subtitle: $subtitle, image: $image, color: $color, iconColor: $iconColor ).padding(.vertical)
                    
                    
                }
                Section{
                    NavigationLink(
                        destination:ArtworkPicker(iconName: $image),
                        label: {
                            HStack {
                                Text("Artwork").foregroundColor(.primary).fontWeight(.semibold)
                                Image(image)
                                    .resizable()
                                    .foregroundColor(Color.secondary)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                            }
                        })
                    
                    
                    
                }
                
                Section(header: Text("Template color scheme")){
                    
                    NavigationLink(
                        destination:TemplateColorSchemePicker(iconName: $image, color: $color, iconColor: $iconColor),
                        label: {
                            HStack(spacing:10) {
                                Text("Choose").foregroundColor(.primary).fontWeight(.semibold)
                                RoundedRectangle(cornerRadius: 3, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color(hexString: iconColor))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.primary, lineWidth: 0.2)
                                    )
                                RoundedRectangle(cornerRadius: 3, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color(hexString: color))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.primary, lineWidth: 0.2)
                                    )
                            }
                        })
                    
                }
                Section(header: Text("Custom color scheme (Optional)")){
                    
                    
                    HStack(spacing:10) {
                        TextField("Icon color hex", text: $iconColor, onCommit:  {
                            if  !iconColor.contains("#") {
                                iconColor = "#F2F2F2"
                            }
                        })
                        RoundedRectangle(cornerRadius: 3, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(hexString: iconColor))
                            .overlay(
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(Color.primary, lineWidth: 0.2)
                            )
                    }
                    
                    
                    HStack(spacing:10) {
                        TextField("Icon background color hex", text: $color, onCommit:  {
                            if  !color.contains("#") {
                                color = "#F2F2F2"
                            }
                        })
                        RoundedRectangle(cornerRadius: 3, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(hexString: color))
                            .overlay(
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(Color.primary, lineWidth: 0.2)
                            )
                    }
                }
                
                
                if showRestrictToggle {
                Section{
                    Toggle(isOn: firstBinding) {
                        Text("Restrict")
                    }
                    Text("Dietary restrictions are grouped together to make them easy to access by customers that have a dietary restrictions.").foregroundColor(.secondary).font(.footnote)
                }
                }
                Section{
                    Button(action: {
                        isLoading = true
                  
                            createCategorie()
                        
                        
                    }) {
                        Text("Create")
                    }.disabled(!requiredFieldsAreFilled)
                }
                
            }
            .navigationBarTitle("Categorie",displayMode: .inline)
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(trailing: closeButtonNavBarItem{presentationMode.wrappedValue.dismiss()})
            }
        }
    }
    
    func someAction(consumableSectionGroup : Int){
        
    }
    
    func createCategorie(){
        // if let newCategorie = store.selectedRestaurant {
        let newConsumableCategorieDict:[String:Any] = [
            "id" : title,
            "title" : title,
            "subtitle" : subtitle,
            "image": image,
            "color": color,
            "iconColor": iconColor,
            "consumablesByID" : consumablesByID,
            "consumableSectionGroup" : Int(consumableSectionGroup) ]
        if let newConsumableCategorie = ConsumableCategorie(dictionary: newConsumableCategorieDict){
            consumableCategorie = newConsumableCategorie
            if let consumableCategorie = consumableCategorie{
              
                store.createConsumableCategorie(consumableCategorie: consumableCategorie){ result in
                    switch result {
                    case let .success(categorie):
                        store.consumableCategories.append(categorie)
                        isLoading = false
                        presentationMode.wrappedValue.dismiss()
                    case .failure:
                        print("Failed")
                        isLoading = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
            }
            isLoading = false
            presentationMode.wrappedValue.dismiss()
        }
        //}
    }
}

//struct CreateConsumableCategorieView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateConsumableCategorieView() .environment(\.colorScheme, .light)
//    }
//}

struct categorieCreatorRow: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var title: String
    @Binding var subtitle: String
    @Binding var image: String
    @Binding var color: String
    @Binding var iconColor: String
    var body: some View {
        ZStack{
            HStack(alignment: .center, spacing: 10) {
                
                if horizontalSizeClass == .compact {
                    Image(image)
                        .resizable()
                        .foregroundColor(Color(hexString: iconColor))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(Color(hexString: color))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    
                } else {
                    
                    Image(image)
                        .resizable()
                        .foregroundColor(Color(hexString: iconColor))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .padding()
                        .background(Color(hexString:color))
                        
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                
                VStack(alignment: .leading, spacing: 8.0) {
                    
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                    Text(subtitle)
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    
                }
                
                
                
            }
        }
    }
}
