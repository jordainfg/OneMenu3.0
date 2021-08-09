//
//  Appearance.swift
//  BaseSwiftUIAPP
//
//  Created by Jordain Gijsbertha on 03/08/2020.
//

import SwiftUI

struct Appearance: View {
    
    @EnvironmentObject var appearanceStore : AppearanceStore
    @State var darkModeIsOn : Bool = UserDefaults.standard.bool(forKey: "darkModeIsOn")
    @State var AutoModeIsOn : Bool = UserDefaults.standard.bool(forKey: "AutoModeIsOn")
    @State var appearance : Bool = false
    var body: some View {
        List {
            
            Section(header: Text("AppearanceHeader")) {
                
                autoAppearanceSwitch(settingName: "Appearance").environmentObject(appearanceStore)
            }
            
            if !appearanceStore.AutoModeIsOn{
            Section(header: Text("AppearanceHeader2")) {
                
                
                    InterfaceModeOptions(appearance: $appearance)
             
                
            }
            }
        }
        .listStyle(InsetGroupedListStyle())
        
        .navigationBarTitle("Appearance")
        .onAppear{
            darkModeIsOn = UserDefaults.standard.bool(forKey: "darkModeIsOn")
        }
        
        
        
    }
}

struct Appearance_Previews: PreviewProvider {
    static var previews: some View {
        Appearance()
    }
}

struct InterfaceModeOptions: View {
    @Binding var appearance : Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: "moon.fill")
                    
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(appearance ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) )
                    .padding(.all, 10)
                    .clipShape(Circle())
                    .onTapGesture {
                        UserDefaults.standard.set(true, forKey: "darkModeIsOn")
                        appearance = true
                        UIApplication.shared.windows.forEach { window in
                            window.overrideUserInterfaceStyle = .dark
                        }
                    }
                Text("DarkMode")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(appearance ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) )
            }
            .frame(height: 200)
            
            Spacer()
            VStack {
                Image(systemName: "sun.max.fill")
                    
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(appearance ? Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))  : Color(#colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1)) )
                    .padding(.all, 10)
                    .clipShape(Circle())
                    .onTapGesture {
                        UserDefaults.standard.set(false, forKey: "darkModeIsOn")
                        appearance = false
                        UIApplication.shared.windows.forEach { window in
                            window.overrideUserInterfaceStyle = .light
                        }
                    }
                Text("LightMode")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(appearance ? Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))  )
            }
            .frame(height: 200)
            
            Spacer()
        }.onAppear{
            if colorScheme == . dark{
                appearance = true
            } else{
                appearance = false
            }
        }
        
    }
}
