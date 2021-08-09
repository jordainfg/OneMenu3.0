//
//  CourseSectionDetail.swift
//  DesignCodeCourse
//
//  Created by Jordain Gijsbertha on 19/08/2020.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
struct ConsumableForSelectionDetail: View {
    @State var isFromSearchView : Bool = false
    
    @State var show : Bool
    @State private var isSettingsExpanded: Bool = true
    var consumable : Consumable?
    @State var image : WebImage?
    var body: some View {
        
        content
        
    }
    
    var content: some View {
        
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                if let consumable = consumable {
                    
                    StrechyConsumableHeader(consumable:consumable, image: image)
                }
                
                VStack {
                    
                    // MARK: - About
                    if let consumable = consumable {
                        VStack(alignment: .leading, spacing: 10.0) {
                            
                            HStack{
                                Divider().frame(width: 1)
                                    .background(Color(hexString: consumable.colorTone))
                                Text(consumable.headline)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hexString: consumable.colorTone))
                            }
                            
                            Text(consumable.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            
                            
                            HStack(spacing:2){
                                Image(systemName: "flame")
                                    .renderingMode(.original)
                                    .font(.body)
                                Text(consumable.calories)
                                    .font(.footnote)
                                Text("kcal").fontWeight(.bold)
                                    .font(.footnote)
                                Divider().frame(maxHeight:20).padding(.horizontal,5)
                                Text("\(consumable.currency)").fontWeight(.bold)
                                Text("\(consumable.price, specifier: "%.2f")")
                                    .font(.footnote)
                                Spacer()
                            }
                            Text(consumable.subtitle)
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }.frame(maxWidth:.infinity)
                        .padding()
                        
                    }
                    
                    // MARK: - Nutrition information
                    if let consumable = consumable {
                        if consumable.hasNutrition{
                            Divider().padding(.horizontal)
                                .padding(.bottom)
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 10.0) {
                                    Text("nutritionInformation")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("nutritionInformationHeaderOne")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("nutritionInformationHeaderTwo")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(2)
                                    
                                }
                                
                                HStack(spacing:0) {
                                    
                                    VStack(spacing: 4) {
                                        RingView(color1: #colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1), color2: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), width: 60, height: 60, percent: CGFloat(consumable.carbsPercentage), show: $show)
                                            .padding(.bottom,20)
                                        
                                        Text("Carbs")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                        Text("\(consumable.carbs)g")
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                    }.frame(maxWidth:.infinity)
                                    
                                    VStack(spacing: 4) {
                                        RingView(color1: #colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1), color2: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), width: 60, height: 60, percent: CGFloat(consumable.proteinPercentage), show: $show)
                                            .padding(.bottom,20)
                                        
                                        Text("Protein")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                        Text("\(consumable.protein)g")
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                    }.frame(maxWidth:.infinity)
                                    
                                    VStack(spacing: 4) {
                                        RingView(color1: #colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1), color2: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), width: 60, height: 60, percent: CGFloat(consumable.fatPercentage), show: $show)
                                            
                                            .padding(.bottom,20)
                                        
                                        Text("Fat")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                        Text("\(consumable.fat)g")
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                    }.frame(maxWidth:.infinity)
                                    
                                }
                                .padding()
                            }.padding(.horizontal)
                            
                            
                            Divider().padding(.horizontal)
                            
                        }
                    }
                    
                    
                    
                    // MARK: - Contents
                    if let consumable = consumable {
                        if consumable.hasIngredients {
                            VStack(alignment: .leading) {
                                
                                Text("ingredientsHeader")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                VStack {
                                    VStack(alignment: .leading){
                                        Text("ingredientsTitle").font(.headline).fontWeight(.bold)
                                        
                                        ForEach(consumable.allergens, id: \.self) { item in
                                            Divider().padding(.vertical,10)
                                            HStack(spacing: 10)  {
                                                
                                                Image(systemName: "info.circle")
                                                    //.renderingMode(.original)
                                                    .font(.body)
                                                    .foregroundColor(Color.primary)
                                                Text(item).font(.subheadline)
                                                    .foregroundColor(Color.primary)
                                                Spacer()
                                            }
                                        }
                                        
                                    }
                                    .font(.headline)
                                    .foregroundColor(Color.primary)
                                    .background(Color("Background 2"))
                                    .padding()
                                    
                                    
                                }
                                .background(Color("Background 2"))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .padding()
                                
                                
                                Text(LocalizedStringKey("TermsofuseSum"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                                
                            }.padding(.horizontal)
                            
                            
                            Divider().padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Options
                    if let consumable = consumable {
                        if consumable.hasOptions {
                            VStack(alignment: .leading) {
                                
                                Text("optionsHeader")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                VStack {
                                    VStack(alignment: .leading){
                                        Text("optionsTitle").font(.headline).fontWeight(.bold)
                                        
                                        ForEach(consumable.options, id: \.self) { item in
                                            Divider().padding(.vertical,10)
                                            HStack {
                                                let extra = item.components(separatedBy: ",")
                                                if extra.count > 0{
                                                    Text(extra[0]).font(.subheadline)
                                                        .fontWeight(.light)
                                                        .foregroundColor(Color.primary)
                                                }
                                                Spacer()
                                                if extra.count == 2{
                                                    Text(extra[1]).font(.subheadline)
                                                        .fontWeight(.light)
                                                        .foregroundColor(Color.secondary)
                                                }
                                            }
                                        }
                                        
                                    }
                                    .font(.headline)
                                    .foregroundColor(Color.primary)
                                    .background(Color("Background 2"))
                                    .padding()
                                    
                                    
                                }
                                .background(Color("Background 2"))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .padding()
                                
                            }.padding(.horizontal)
                            Divider().padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Extra's
                    if let consumable = consumable {
                        if consumable.hasExtras{
                            VStack(alignment: .leading) {
                                
                                Text("extrasHeader")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                
                                
                                VStack {
                                    VStack(alignment: .leading){
                                        Text("extrasTitle").font(.headline).fontWeight(.bold)
                                        
                                        ForEach(consumable.extras, id: \.self) { item in
                                            Divider().padding(.vertical,10)
                                            HStack {
                                                let extra = item.components(separatedBy: ",")
                                                if extra.count > 0{
                                                    Text(extra[0]).font(.subheadline)
                                                        .fontWeight(.light)
                                                        .foregroundColor(Color.primary)
                                                }
                                                Spacer()
                                                if extra.count == 2{
                                                    Text(extra[1]).font(.subheadline)
                                                        .fontWeight(.light)
                                                        .foregroundColor(Color.secondary)
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    .font(.headline)
                                    .foregroundColor(Color.primary)
                                    .background(Color("Background 2"))
                                    
                                    .padding()
                                }
                                .background(Color("Background 2"))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .padding()
                                
                            }.padding(.horizontal)
                        }
                    }
                } 
            })
        }
        .navigationBarTitle("",displayMode: .large)
        
        .onAppear {
            show = false
            show = true
        }
    }
    
    
    
}


struct CourseSectionDetail_Previews: PreviewProvider {
    static var previews: some View {
        ConsumableForSelectionDetail( show: true)
    }
}

struct StrechyConsumableHeader : View{
    
    var consumable: Consumable?
    
    @State var image : WebImage?
    
    @State var imageUrl : URL?
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    // 2
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    var body : some View{
        
        
        VStack(alignment:.center){
            ZStack{
                GeometryReader { geometry in
                    if let image = image{
                        
                        image
                            .placeholder {
                                Image(systemName: "photo")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.primary)
                                
                                
                            }
                            .resizable()
                            .background(Color("grouped"))
                            .scaledToFill()
                            .overlay(TintOverlay().opacity(0.1))
                            .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry)) 
                            .clipped()
                            .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                            
                        
                    }
                    
                }
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .frame(height:screen.height/3.5 , alignment: .topLeading)
                .shadow(color: Color.primary.opacity(0.2), radius: 20, x: 0, y: 10)
                
            }
            
            
        }
        
        .edgesIgnoringSafeArea(.top)
        
    }
    
}


