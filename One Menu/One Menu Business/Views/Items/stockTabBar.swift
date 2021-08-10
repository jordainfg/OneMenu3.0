//
//  stockTabBar.swift
//  ShelfApp
//
//  Created by Jordain Gijsbertha on 05/02/2021.
//

import Foundation
import SwiftUI

public struct stockTabBar : View {
    @Binding public var selectedIndex: Int
    
    public let items: [tabBarItem]
    
    public init(selectedIndex: Binding<Int>, items: [tabBarItem]) {
        self._selectedIndex = selectedIndex
        self.items = items
    }
    
    func itemView(at index: Int) -> some View {
        Button(action: {
            withAnimation { self.selectedIndex = index }
        }) {
            tabBarItemView(isSelected: index == selectedIndex, item: items[index])
        }.frame(maxWidth:.infinity)
        .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
    }
    
    public var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            ForEach(0..<items.count) { index in
                self.itemView(at: index)
                
                
            }
            Spacer()
        }
        .padding(.bottom,28)
        .frame(maxWidth:.infinity)
        .animation(.none)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color("whiteToDarkGrouped"))
    }
}


public struct tabBarItem {
    public let icon: String
    public let title: String
    public let color: Color
    
    public init(icon: String,
                title: String,
                color: Color) {
        self.icon = icon
        self.title = title
        self.color = color
    }
}

public struct tabBarAnimatedItemView: View {
    public let isSelected: Bool
    public let item: tabBarItem
    
    public var body: some View {
        HStack {
            Image(systemName: item.icon)
                .renderingMode(.template)
                .font(.headline)
                .foregroundColor(isSelected ? item.color : .secondary)
            
            if isSelected {
                Text(item.title)
                    .foregroundColor(item.color)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
        }
        .padding()
        .background(
            Capsule()
                .fill(isSelected ? item.color.opacity(0.2) : Color.clear)
        )
    }
}
public struct tabBarItemView: View {
    public let isSelected: Bool
    public let item: tabBarItem
    
    public var body: some View {
        HStack {
            Image(systemName: item.icon)
                .renderingMode(.template)
                .font(.title3)
                .foregroundColor(isSelected ? item.color : .secondary)
        }
        .padding(.horizontal)
        .padding(.vertical,15)
       
    }
}
