//
//  ChangeColorTheme.swift
//  ShelfApp
//
//  Created by Jordain on 18/06/2021.
//

import SwiftUI
enum colorScheme : String {
    case dark = "Dark"
    case light = "Light"
    case system = "System"
}
/**
  To use `ChangeColorThemeSegment` go in your SwiftUI app add  the following:
     - `@AppStorage("selectedColorScheme") private var selectedColorScheme : colorScheme = .system`
     - `.environment(\.colorScheme, selectedColorScheme == .system ? UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light : selectedColorScheme == .dark ? .dark : .light )`
 */
struct ChangeColorThemeSegment: View {
    
    
    var foregroundColor : Color = .white
    var isBold: Bool = false
    
    var colorSchemes : [colorScheme ] = [.dark,.light,.system]
    
    @AppStorage("selectedColorScheme") private var selectedColorScheme : colorScheme = .system
    var body: some View {
        
        HStack(spacing: 12.0) {
            Label("Theme", systemImage: selectedColorScheme == .system ? "circle.lefthalf.fill" : selectedColorScheme == .light ? "sun.max.fill" : "moon.fill")
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            
            Spacer()
            
            Picker(selection: $selectedColorScheme, label: Text("")) {
                ForEach(colorSchemes, id: \.self) { language in
                    Text(language.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            .onReceive([self.selectedColorScheme].publisher.first()) { value in
                selectedColorScheme = value
            }
        }
        .padding(.trailing, 5)
        .padding(.vertical, 5)
        .frame(maxWidth : . infinity)
        .background(Color.white.opacity(0.00000000001))
        .listItemTint(selectedColorScheme == .system ? Color.primary : selectedColorScheme == .light ? Color.yellow : Color.purple)
        
        
    }
    
}

//struct ChangeColorTheme_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeColorThemeSegment()
//    }
//}
