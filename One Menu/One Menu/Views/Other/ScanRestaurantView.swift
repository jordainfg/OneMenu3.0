//
//  ScanRestaurantView.swift
//  One_Menu
//
//  Created by Jordain Gijsbertha on 04/08/2020.
//

import SwiftUI
import CoreHaptics

struct ScanRestaurantView: View {
    
    @ObservedObject var store : DataStore

    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var showFailedAlert = false
  
    @State private var engine: CHHapticEngine?
    
    @AppStorage("ScannedRestaurant") var ScannedRestaurant : String = ""
    
    func handleScan(result: Result<String, QrCodeScannerView.ScanError>) {
       
        switch result {
        case .success(let code):
            var parsedCode = code
            if let range = code.range(of: "link/") {
                let phone = code[range.upperBound...]
                parsedCode = String(phone) // prints "123.456.7891"
            }
            
            ScannedRestaurant = parsedCode
    
            if !parsedCode.isEmpty{
                presentationMode.wrappedValue.dismiss()
              
            } else {
                print("Scanning failed")
                showFailedAlert = true
            }
        case .failure:
            print("Scanning failed")
            showFailedAlert = true
            
        }
    }
    
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 10.0) {
                Text(LocalizedStringKey("scanTitle")).font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
               
                Text(LocalizedStringKey("scanSubTitle")).font(.subheadline).fontWeight(.medium).foregroundColor(.white)
                
                    
                Spacer()
                CircularButton(systemName:"xmark"){ self.showingAlert = true}
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(LocalizedStringKey("scanAlertOneTitle")), message: Text(LocalizedStringKey("scanAlertOneSubTitle")), primaryButton: .destructive(Text("Yes")) {
                                ScannedRestaurant = ""
                                presentationMode.wrappedValue.dismiss()
                                  }, secondaryButton: .cancel())
                            }
                Button(action: {}, label: {}).alert(isPresented: $showFailedAlert) {
                    Alert(title: Text("Oops"), message: Text(LocalizedStringKey("scanAlertTwoSubTitle")), dismissButton: .destructive(Text("Okay")) {
                            presentationMode.wrappedValue.dismiss()
                        })
                        }
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            
            QrCodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
                .cornerRadius(5)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            
        }
    }
}

struct ScanRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        ScanRestaurantView(store: DataStore())
    }
}
