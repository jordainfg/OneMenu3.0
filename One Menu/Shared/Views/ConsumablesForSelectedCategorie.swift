//
//  CourseDetail.swift
//  DesignCodeCourse
//
//  Created by Jordain Gijsbertha on 19/08/2020.
//
import SwiftUI
import SDWebImageSwiftUI
struct ConsumablesForSelectedCategorie: View {
   
    var selectedCategorie: ConsumableCategorie?
    @State var showModal = false
    @ObservedObject var store : DataStore
    @State var imagess : [String : WebImage] = [String: WebImage]()
    
    @State var allConsumables : [Consumable]  = []
    
    @State var selectedConsumables : [Consumable] = []
    
    @State var consumablesByID : [String] = []
    
    var body: some View {
        

        if let consumableGategorie = selectedCategorie{
            content
                .navigationBarTitle(Text(consumableGategorie.title),displayMode: .inline)
                .edgesIgnoringSafeArea(.bottom)
        } else{
            VStack{
                Text("Currentlyunavailable").font(.caption).fontWeight(.semibold).foregroundColor(.secondary)
                Text("pleasetry").font(.caption).fontWeight(.semibold).foregroundColor(.secondary)
            }.padding(.top,20)
        }
      
        
    }
    
    var content: some View {
     
            ScrollView{
                if let consumableGategorie = selectedCategorie{

                        VStack(alignment: .center,spacing:10) {
                            Text(consumableGategorie.subtitle).font(.subheadline).foregroundColor(Color.secondary).lineLimit(3).multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true).padding()
                            Divider()
                            }.padding(.all)
           
                }
                VStack {
                    ForEach(selectedConsumables) { item in
                        if selectedConsumables.count == 0 {
                            VStack{
                                Text("comingsoon").font(.subheadline).foregroundColor(.secondary).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                
                                
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            NavigationLink(destination: ConsumableForSelectionDetail(show: showModal, consumable : item, image : imagess[item.consumableID])){
                                ConsumableRow(item: item, image : imagess[item.consumableID])
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
            }.onAppear{
                if let selectedCategorie = selectedCategorie {
                allConsumables = store.consumables
                consumablesByID = selectedCategorie.consumablesByID
                selectedConsumables = allConsumables.filter { consumablesByID.contains($0.consumableID)}
                allConsumables = allConsumables.filter { !consumablesByID.contains($0.consumableID)}
                }
        }
    
        
    }
}

struct ConsumableDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        ConsumablesForSelectedCategorie(store: DataStore())
    }
}
struct StrechySectionHeader : View{

    var consumableSection: ConsumableCategorie?

    var body : some View{
        VStack(alignment:.center){ 
            ZStack{
                if let consumableSection = consumableSection{
                GeometryReader { geometry in
                    if geometry.frame(in: .global).minY <= 0 {
                        VStack(alignment: .leading, spacing: 4.0) {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(consumableSection.image)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(0.5)
                                    .foregroundColor(Color(hexString: consumableSection.iconColor))
                                    .shadow(color: Color(hexString: consumableSection.iconColor).opacity(0.9) as? Color ?? Color.black.opacity(0.3), radius: 10, x: 0, y: 20)
                                    .background(Color("Background 1"))
                                    .clipShape(Circle())
                                    .shadow(color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)).opacity(0.2), radius: 6, x: 0, y: 3)
                                Spacer()
                            }
                            Text(consumableSection.title).font(.largeTitle).fontWeight(.bold).foregroundColor(Color.primary)
                            Text(consumableSection.subtitle).font(.footnote).foregroundColor(Color.secondary)
                        }
                        .padding(.all)
                        
                        .shadow(color:Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                        .frame(width: geometry.size.width,
                               
                               height: geometry.size.height)
                        
                        
                    } else {
                        VStack(alignment: .leading, spacing: 4.0) {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(consumableSection.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(0.5)
                                    .foregroundColor(Color(hexString: consumableSection.iconColor))
                                    .shadow(color: Color(hexString: consumableSection.iconColor).opacity(0.9) as? Color ?? Color.black.opacity(0.3), radius: 10, x: 0, y: 20)
                                    .background(Color("Background 1"))
                                    .clipShape(Circle())
                                    .shadow(color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)).opacity(0.2), radius: 6, x: 0, y: 3)
                                Spacer()
                            }
                            Text(consumableSection.title).fontWeight(.bold).foregroundColor(Color.primary)
                            Text(consumableSection.subtitle).font(.footnote).foregroundColor(Color.secondary)
                        }
                        .padding(.all)
                        
                        .shadow(color:Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                        .offset(y: -geometry.frame(in: .global).minY)
                        .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                        
                    }
                    
                }
                .frame(height: screen.height / 3.2 )
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

let screen = UIScreen.main.bounds
