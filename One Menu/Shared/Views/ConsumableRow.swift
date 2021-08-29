//
//  CourseRow.swift
//  DesignCodeCourse
//
//  Created by Jordain Gijsbertha on 19/08/2020.
//
import SwiftUI
import SDWebImageSwiftUI
struct ConsumableRow: View {
    var item: Consumable?
    @State var image : WebImage?
    var body: some View {
        VStack {
            if let item = item {
                if let image = image{
                    HStack(alignment: .center,spacing:20) {
                        image
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .imageScale(.large)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                        
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text(item.title)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.primary)
                            Text(item.subtitle)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                }
            }
            
        }
    }
}

struct CourseRow_Previews: PreviewProvider {
    static var previews: some View {
        ConsumableRow()
    }
}
