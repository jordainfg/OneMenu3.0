//
//  SettingsSwitch.swift
//  BaseSwiftUIAPP
//
//  Created by Jordain Gijsbertha on 03/08/2020.
//

import SwiftUI

struct autoAppearanceSwitch: View {
    @State private var autoMode = true
    var settingName : String
    @EnvironmentObject var appearanceStore : AppearanceStore
    @State var AutoModeIsOn : Bool = UserDefaults.standard.bool(forKey: "AutoModeIsOn") {
        didSet{
            change()
        }
    } //false
    
    func change(){
      
        appearanceStore.AutoModeIsOn = !appearanceStore.AutoModeIsOn
        UserDefaults.standard.set(appearanceStore.AutoModeIsOn, forKey: "AutoModeIsOn")
        
        if !AutoModeIsOn{
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            
            
        } else if AutoModeIsOn {
            
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
    
    
    
    var body: some View {
        let bind = Binding<Bool>(
            get:{self.AutoModeIsOn},
            set:{self.AutoModeIsOn = $0}
        )
        
        HStack {
            Toggle(isOn: bind) {
                Text("Automatically")
                    .font(.caption)
                    .fontWeight(.medium)
                
            }
            .padding()
            
            
        }
    }
}

struct SettingsSwitch_Previews: PreviewProvider {
    static var previews: some View {
        autoAppearanceSwitch(settingName: "Auto")
    }
}
