//
//  TemplateColorSchemePicker.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 26/01/2021.
//

import SwiftUI
struct templateColorCombo :Identifiable,Hashable {
    var id = UUID()
    var color : String
    var iconColor : String
}

struct TemplateColorSchemePicker: View {
    @Binding var iconName : String
    @Binding var color : String
    @Binding var iconColor : String
    @Environment(\.presentationMode) var presentationMode
    
    var pastels = [
        templateColorCombo(color: "#FAE0DC", iconColor:"#FC7262"),
        templateColorCombo(color: "#CBE3FE", iconColor:"#7880ED"),
        templateColorCombo(color: "#C9EAE1", iconColor:"#2FBE56"),
        templateColorCombo(color: "#FFEEEE", iconColor:"#F9504E"),
        
        templateColorCombo(color: "#F2F2F7", iconColor:"#1B426C"),
        templateColorCombo(color: "#F1F1F6", iconColor:"#2B8A3E"),
        templateColorCombo(color: "#F1F1F6", iconColor:"#8E3036"),
        templateColorCombo(color: "#F1F1F6", iconColor:"#FB7593"),
        templateColorCombo(color: "#F1F1F6", iconColor:"#F2A400"),
        templateColorCombo(color: "#F1F1F6", iconColor:"#A95E3D"),
        templateColorCombo(color: "#F1F1F6", iconColor:"#FA2A41"),
        templateColorCombo(color: "#F1F1F6", iconColor:"#000000")
        ]
    var icons = [
        templateColorCombo(color: "#FD6746", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#1AB55C", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#5628EE", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#DA3657", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#000000", iconColor:"#EA4840"),
        templateColorCombo(color: "#FF415B", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#EC4EA5", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#1E1E1E", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#186AE2", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#FF62F5", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#B91E28", iconColor:"#FFFFFF"),
        templateColorCombo(color: "#FFA91C", iconColor:"#FFFFFF")
    ]
    var body: some View {
        ScrollView {
            VStack(spacing:20) {
            
            SectionText2(text: "Relaxed").padding(10).foregroundColor(.secondary)
        
           
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 70,maximum: 80), spacing: 20)],
                spacing: 20
            ) {
                
               
                ForEach(pastels, id: \.self)  { icon in
                    Button(action: {
                        color = icon.color
                        iconColor = icon.iconColor
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CategorieIconTemplate(imageName: iconName ,color: icon.color, iconColor: icon.iconColor)
                    }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                    
                    
                }
                
                
                
            }
            
            SectionText2(text: "Vibrant").padding(10).foregroundColor(.secondary)
            
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 70,maximum: 80), spacing: 20)],
                spacing: 20
            ) {
                
                //SectionText2(text: "Vibrants")
                ForEach(icons, id: \.self)  { icon in
                    Button(action: {
                        color = icon.color
                        iconColor = icon.iconColor
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CategorieIconTemplate(imageName: iconName ,color: icon.color, iconColor: icon.iconColor)
                    }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                    
                    
                }
                
                
            }
        }.padding()
        }.navigationTitle("Color scheme")
        
    }
}



struct CategorieIconTemplate: View  {
    @State var imageName: String = "icons8-avocado-50"
    @State var color: String = ""
    @State var iconColor: String = "String"
    var body: some View {
        
        Image(imageName)
            .resizable()
            .foregroundColor(Color(hexString: iconColor))
            .aspectRatio(contentMode: .fill)
            .padding()
            .background(Color(hexString: color))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
}
