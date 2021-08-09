//
//  moreListRow.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 03/02/2021.
//

import SwiftUI

struct moreListRow: View {
    var name : String = ""
    var systemName : String = ""
    var iconName : String = ""
    var color : Color = Color.primary
    var body: some View {
                HStack{
                    
                    if iconName.count == 0 {
                        Image(systemName: systemName)
                            .renderingMode(.template)
                            .font(.title2)
                            .foregroundColor(color)
                    } else{
                        Image(iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.vertical,8)
                    }
                    Text(name)
                        .font(.headline)
                        .fontWeight(.semibold)
                }.padding(5)
            
    }
}


struct moreListRow_Previews: PreviewProvider {
    static var previews: some View {
        moreListRow()
    }
}
