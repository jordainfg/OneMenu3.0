//
//  QrCodeView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 25/01/2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QrCodeView: View {
    @State  var restaurantID = "ssssssss"
    @State private var showShareSheet = false
    @State private var showingSubscriptionView = false
    @State var items : [Any] = []
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    // Step One: We need two properties to store an active Core Image context and an instance of Core Image’s QR code generator filter.
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @ObservedObject var store: AdminDataStore
    
    var body: some View {
        
        List {
            VStack {
                descriptionText(text: "The unique QR code provided below can be printed and placed around your restaurant. A customer can then scan the QR code to browse your menu.").padding(.top)
                    
                VStack {
                    VStack {
                        Image(uiImage: generateQRCode(from: "\(restaurantID)"))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                            .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)), lineWidth: 2)
                                )
                            
                            
                            
                        
                    }
                    .padding(6)
                    .padding()
                    .redacted(reason: !isPremiumUser ? .placeholder : [] )
                    
                    Button(action: {
                        // your action here
                        if isPremiumUser{
                        items.removeAll()
                        items.append(generateQRCode(from: "\(restaurantID)").resized(toWidth: 512) ?? UIImage())
                      
                            showShareSheet = true
                        } else {
                            showingSubscriptionView = true
                        }
                        
                    }) {
                        
                            Image(systemName: "square.and.arrow.up")
                                .renderingMode(.template)
                                .font(Font.title.weight(.bold))
                                .padding(.vertical,10)
                                .foregroundColor(Color.white)
                                .padding()
                                .padding(.bottom,3)
                                .background(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .shadow(color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)).opacity(0.4), radius: 20, x: 0, y: 5)
                            
                        
                            
                    }
                    .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                    
                    descriptionText(text: "With the introduction of iOS 14, your customers don't even have to download the one menu app to browse your menu.* They can simply scan the QR code that you provide in your restaurant and your menu will load in a blink of an eye. You can try it out by scanning the QR code above. ")
                        .padding(.vertical)
                        .sheet(isPresented: $showShareSheet, content: {
                        ShareSheet(items: $items)
                    })
                    Text("*QR code scanning is only available for iOS 14 users. iOS 13 users can access your menu by manualy downloading the one menu app from the app store.").multilineTextAlignment(.center).font(.footnote).foregroundColor(.secondary).padding(.vertical).fixedSize(horizontal: false, vertical: true)
                        .sheet(isPresented: $showingSubscriptionView){
                                            SubscriptionView()
                                        }
                    
                 
                }
                .background(Color.white)
                
            }.frame(maxWidth:.infinity)
        }.listStyle(InsetGroupedListStyle())
        .onAppear{
            
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}

struct QrCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QrCodeView( store: AdminDataStore())
    }
}
struct descriptionText: View {
    var text : String
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .padding(.horizontal)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
    }
}

struct ShareSheet : UIViewControllerRepresentable{
    
    @Binding var items : [Any]
    
    func makeUIViewController(context: Context) -> some UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewDidLoad()
    }
}
extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: round(width), height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext();
        context?.interpolationQuality = .none
        // Set the quality level to use when rescaling
        draw(in: CGRect(origin: .zero, size: canvasSize))
        let r = UIGraphicsGetImageFromCurrentImageContext()
        return r
    }
}
