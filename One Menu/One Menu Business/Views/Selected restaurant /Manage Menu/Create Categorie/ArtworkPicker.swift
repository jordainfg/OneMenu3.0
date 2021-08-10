//
//  ArtworkPicker.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 26/01/2021.
//

import SwiftUI

struct ArtworkPicker: View {
    @Binding var iconName : String
    
    @Environment(\.presentationMode) var presentationMode
    var universalArtworkNames : [String: String] = [
        "icons8-croissant-50" : "Breakfast",
        "icons8-fry-50" : "Lunch",
        "icons8-food-and-wine-50" : "Dinner",
        "icons8-nachos-50" : "Snacks",
        "icons8-coffee-50" : "Coffee",
        "icons8-tea-50" : "Tea",
        "icons8-blender-50" : "Smoothies",
        "icons8-fish-and-vegetables-50" : "Sea food",
        "icons8-ice-cream-cone-50" : "Dessert",
        "icons8-salad-50" : "Salads",
        "icons8-salmon-sushi-50" : "Sushi",
        "icons8-soup-plate-50" : "Soups"
        
    ]
    
    var universalDTArtworkNames : [String: String] = [
        "icons8-vegetarian-mark-50" : "Vegetarian",
        "icons8-vegan-symbol-50" : "Vegan",
        "icons8-no-gluten-50" : "Gluten",
        "icons8-halal-sign-50" : "Halal",
        "icons8-peanut-50" : "Nut",
        "icons8-no-shellfish-50" : "Shellfish",
        "icons8-no-soy-50" : "Soy",
        "icons8-non-lactose-food-50" : "Lactose",
        "icons8-dairy-50" : "Dairy",
        "icons8-diabetic-food-50" : "Sugar",
        "icons8-paleo-diet-50" : "Paleo",
        "icons8-no-crustaceans-50" : "Crustaceans",
        "icons8-no-fish-50" : "Fish",
        "icons8-no-fructose-50" : "Fructose",
        "icons8-no-lupines-50" : "Lupines",
        "icons8-no-meat-50" : "Meat free"
      
        
    ]
    
    var allArtworkNames = ["icons8-soup-plate-50","icons8-nachos-50", "icons8-croissant-50","icons8-fry-50","icons8-wrap-50","icons8-apple-50","icons8-apricot-50","icons8-banana-50","icons8-banana-split-50","icons8-barbecue-50","icons8-beef-50","icons8-beer-50","icons8-beet-50","icons8-bento-50","icons8-bitten-sandwich-50","icons8-blender-50","icons8-bread-50","icons8-bread-and-rolling-pin-50","icons8-bread-and-rye-50","icons8-broccoli-50","icons8-burrito-50","icons8-cabbage-50","icons8-cake-50","icons8-carrot-50","icons8-cauliflower-50","icons8-caviar-50","icons8-celery-50","icons8-champagne-50","icons8-cheese-50","icons8-chili-pepper-50","icons8-chinese-fried-rice-50","icons8-chinese-noodle-50","icons8-cinnamon-roll-50","icons8-coconut-milk-50","icons8-coffee-50","icons8-coffee-beans-50","icons8-cola-50","icons8-corn-50","icons8-crab-50","icons8-cucumber-50","icons8-cupcake-50","icons8-cuts-of-beef-50","icons8-eggplant-50","icons8-eggs-50","icons8-filleted-fish-50","icons8-fish-food-50","icons8-flour-50","icons8-fondue-50","icons8-french-fries-50","icons8-fried-chicken-50","icons8-garlic-50","icons8-ginger-50","icons8-grains-of-rice-50","icons8-guacamole-50","icons8-hamburger-50","icons8-hazelnut-50","icons8-healthy-food-50","icons8-hemp-milk-50","icons8-international-food-50","icons8-tapas-50","icons8-lasagna-50","icons8-lime-50","icons8-low-salt-50","icons8-macaron-50","icons8-milk-bottle-50","icons8-mushroom-50","icons8-noodles-50","icons8-oat-milk-50","icons8-octopus-50","icons8-olive-50","icons8-olive-oil-50","icons8-onion-50","icons8-orange-50","icons8-orange-juice-50","icons8-organic-food-50","icons8-pancake-50","icons8-peanuts-50","icons8-peas-50","icons8-pear-50","icons8-pizza-50","icons8-potato-50","icons8-poultry-leg-50","icons8-prawn-50","icons8-pretzel-50","icons8-rack-of-lamb-50","icons8-radish-50","icons8-refreshments-50","icons8-rolled-oats-50","icons8-street-food-50","icons8-whipped-cream-50","icons8-watermelon-50","icons8-thanksgiving-50"
        ,"icons8-taco-50","icons8-sparkling-water-50","icons8-shrimp-and-lobster-50","icons8-sandwich-with-fried-egg-50","icons8-quesadilla-50"
    
    ]
    var body: some View {
        ScrollView {
            VStack(spacing:20) {
                SectionText2(text: "Universal").foregroundColor(.secondary).padding(10)
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 80,maximum: 80), spacing: 20)],
                spacing: 20
            ) {
                ForEach(universalArtworkNames.sorted(by: >), id: \.key)  { key, value in
                    Button(action: {
                        iconName = key
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack(alignment: .center,spacing: 5) {
                            Image(key)
                                .resizable()
                                .foregroundColor(Color.primary)
                                .aspectRatio(contentMode: .fill)
                                .padding()
                                .background(Color("grouped"))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            Text("\(value)").font(.caption2).fontWeight(.semibold).foregroundColor(.secondary)
                        }
                    }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                }
                
                
            }
                SectionText2(text: "Dietary restrictions").foregroundColor(.secondary).padding(10)
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 80,maximum: 80), spacing: 20)],
                spacing: 20
            ) {
               
                ForEach(universalDTArtworkNames.sorted(by: >), id: \.key)  { key, value in
                    Button(action: {
                        iconName = key
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack(alignment: .center,spacing: 5) {
                            Image(key)
                                .resizable()
                                .foregroundColor(Color.primary)
                                .aspectRatio(contentMode: .fill)
                                .padding()
                                .background(Color("grouped"))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            Text("\(value)").font(.caption2).fontWeight(.semibold).foregroundColor(.secondary)
                        }
                    }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                }
                
                
            }
                SectionText2(text: "More").foregroundColor(.secondary).padding(10)
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 80,maximum: 80), spacing: 20)],
                spacing: 20
            ) {
                ForEach(allArtworkNames, id: \.self)  { name in
                    Button(action: {
                        iconName = name
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(name)
                            .resizable()
                            .foregroundColor(Color.primary)
                            .aspectRatio(contentMode: .fill)
                            .padding()
                            .background(Color("grouped"))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                }
                
                
            }
            Divider()
            VStack(alignment:.leading) {
                Text("If you would like for us to support more categories please don't hesitate to contact us.").font(.subheadline).fontWeight(.semibold).foregroundColor(.secondary).padding().multilineTextAlignment(.center)
                
                
                Button(action: {
                    guard let instagram = URL(string: "https://wa.me/message/LQGXHL7RCFN6D1") else { return }
                     UIApplication.shared.open(instagram)
                     
                }) {
                    HStack{
                        Spacer()
                        Text("Contact").foregroundColor(Color(#colorLiteral(red: 1, green: 0.4335931838, blue: 0.377388984, alpha: 1))).fontWeight(.bold)
                        Spacer()
                    }
                }.padding(.bottom,30)
            }
            .background(Color("grouped"))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(15)
            
            
        }.padding()
        .navigationTitle("Artwork")
        }
    }
}



