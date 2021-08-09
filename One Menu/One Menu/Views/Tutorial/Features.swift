//
//  Features.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 18/08/2020.
//

import SwiftUI

struct Features: View {
    var body: some View {
        VStack(alignment: .center) {
                    
            Image("Insights")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(0.7)
            Text("Features")
                .fontWeight(.black)
                .font(.system(size: 36, design: .rounded))
                .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                
            
            
            InformationDetailView(title: "Interactivity", subTitle: "interactivityDetail", imageName: "", systemName: "line.horizontal.3.decrease.circle").padding(.top)
               
            InformationDetailView(title: "Visuals", subTitle: "visualsDetail", imageName: "", systemName: "doc.richtext").padding(.top)
               
            InformationDetailView(title: "Insights", subTitle: "insightsDetail", imageName: "", systemName: "doc.plaintext")
                .padding(.top)
                .padding(.bottom,30)
                
            Spacer()
            
        }
        
        
        
        
    }
}

struct Features_Previews: PreviewProvider {
    static var previews: some View {
        Features()
    }
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"
    var systemName: String = "car"
    var body: some View {
        HStack(alignment: .center) {
            
            if imageName.count == 0 {
                Image(systemName: systemName)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .padding()
                    .accessibility(hidden: true)
            } else{
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.primary)
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
            
            VStack(alignment: .leading, spacing: 5.0) {
                Text(LocalizedStringKey(title))
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)
                
                Text(LocalizedStringKey(subTitle))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            Spacer()
        }
        
        .padding(.horizontal)
    }
}
