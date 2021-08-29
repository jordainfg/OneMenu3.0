//
//  SettingsOption.swift
//  BaseSwiftUIAPP
//
//  Created by Jordain Gijsbertha on 03/08/2020.
//

import SwiftUI

struct SettingsOption: View {
    var settingName : String
    var settingIconSystemName : String
    var settingIconName : String
    var iconBackgroundColor : UIColor
    var foregroundColor : Color = .white
    var isBold: Bool = false
    var body: some View {
        
        HStack(spacing: 12.0) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor(Color(iconBackgroundColor))
                if settingIconName.count == 0 {
                    Image(systemName: settingIconSystemName)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                } else{
                    Image(settingIconName)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(foregroundColor)
                }
                
            }
            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Text(LocalizedStringKey(settingName))
                .font(.footnote)
                .fontWeight(isBold ? .medium :.regular)
                .foregroundColor(.primary)
                .lineLimit(1)
            Spacer()
        }
        .padding(.trailing, 5)
        .padding(.vertical, 5)
        .frame(maxWidth : . infinity)
        .background(Color.white.opacity(0.00000000001))
        
        
        
        
    }
    
}
struct SettingsOptionLarge: View {
    var settingName : String
    var settingIconSystemName : String
    var settingIconName : String
    var iconBackgroundColor : UIColor
    var foregroundColor : Color = .white
    var isBold: Bool = false
    var body: some View {
        
        HStack(spacing: 12.0) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor(Color(iconBackgroundColor))
                if settingIconName.count == 0 {
                    Image(systemName: settingIconSystemName)
                        .font(.title)
                     
                        .foregroundColor(foregroundColor)
                } else{
                    Image(settingIconName)
                        .resizable()
                        .frame(width: 34, height: 34, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(foregroundColor)
                        
                }
                
            }
            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.vertical,5)
            Text(LocalizedStringKey(settingName))
                .font(.body)
                .fontWeight(isBold ? .medium :.regular)
                .foregroundColor(.primary)
                .lineLimit(1)
            Spacer()
        }
        .padding(.trailing, 5)
        .padding(.vertical, 5)
        .frame(maxWidth : . infinity)
        .background(Color.white.opacity(0.00000000001))
        
        
        
        
    }
    
}


struct SettingsOptionSwitch: View {
    var settingName : String
    var settingIconSystemName : String
    var settingIconName : String
    var iconBackgroundColor : UIColor
    var foregroundColor : Color = .white
    var isBold: Bool = false
    @State private var firstToggle = true
    var toggleOnAction: () -> ()
    var toggleOffAction: () -> ()
    var body: some View {
        let firstBinding = Binding(
            get: { self.firstToggle },
            set: {
                self.firstToggle = $0
                
                if $0 == true {
                    toggleOnAction()
                } else  {
                    toggleOffAction()
                }
            }
        )
        return  Toggle(isOn: firstBinding) {
        HStack(spacing: 12.0) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor(Color(iconBackgroundColor))
                if settingIconName.count == 0 {
                    Image(systemName: settingIconSystemName)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                } else{
                    Image(settingIconName)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(foregroundColor)
                }
                
            }
            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Text(LocalizedStringKey(settingName))
                .font(.footnote)
                .fontWeight(isBold ? .medium :.regular)
                .foregroundColor(.primary)
                .lineLimit(1)
            Spacer()
        }
        .padding(.trailing, 5)
        .padding(.vertical, 5)
        .frame(maxWidth : . infinity)
        .background(Color.white.opacity(0.00000000001))
        
        
        }
        
    }
    
}
struct SettingsOptionButton: View {
    var settingName : String
    var settingIconSystemName : String
    var settingIconName : String
    var iconBackgroundColor : UIColor
    var foregroundColor : Color = .white
    var isBold: Bool = false
    
    var customAction: () -> ()
    var body: some View {
        Button(action: {
           customAction()
        }){
        HStack(spacing: 12.0) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor(Color(iconBackgroundColor))
                if settingIconName.count == 0 {
                    Image(systemName: settingIconSystemName)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                } else{
                    Image(settingIconName)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(foregroundColor).padding(2)
                }
                
            }
            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Text(LocalizedStringKey(settingName))
                .font(.footnote)
                .fontWeight(isBold ? .medium :.regular)
                .foregroundColor(.primary)
                .lineLimit(1)
            Spacer()
        }
        .padding(.trailing, 5)
        .padding(.vertical, 5)
        .frame(maxWidth : . infinity)
        .background(Color.white.opacity(0.00000000001))
        
        
        }
        
    }
    
}
