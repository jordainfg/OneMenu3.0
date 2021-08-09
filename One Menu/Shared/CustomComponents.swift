//
//  CustomComponents.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 28/01/2021.
//

import Foundation
import SwiftUI
import MessageUI

struct swifti: View {
    @State var test = ""
    var body: some View {
      
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                  Spacer()
            
        }
        .frame(maxWidth : .infinity, maxHeight: .infinity)
        .background(Color.red)
        .overlay(customToolBar(isVisable: true, firstButtonAction: {}, deleteButtonAction: {}))
                
        
    }
}

// MARK: - Alerts

enum alerts: Identifiable {
    case showSuccessAlert, showFailedAlert,showValidationAlert,showSubscribeAlert
    
    var id: Int {
        hashValue
    }
}
// MARK: - Colors

extension Color {
    public static var primaryOne: Color {
        return Color(#colorLiteral(red: 0.9882352941, green: 0.4470588235, blue: 0.3843137255, alpha: 1))
    }
    public static var primaryTwo: Color {
        return Color(#colorLiteral(red: 0.768627451, green: 0.2509803922, blue: 0.2156862745, alpha: 1))
    }
    public static var secondaryOne: Color {
        return Color(#colorLiteral(red: 0.1333333333, green: 0.2196078431, blue: 0.262745098, alpha: 1))
    }
    public static var secondaryTwo: Color {
        return Color(#colorLiteral(red: 0.4549019608, green: 0.5490196078, blue: 0.6705882353, alpha: 1))
    }
    public static var NeutralDark: Color {
        return Color(#colorLiteral(red: 0.1019607843, green: 0.1294117647, blue: 0.3176470588, alpha: 1))
    }
    public static var NeutralLight: Color {
        return Color(#colorLiteral(red: 0.8901960784, green: 0.9098039216, blue: 1, alpha: 1))
    }
}
// MARK: - Text

struct SectionText2: View {
    var text : String
    var body: some View {
        Text(text).font(.headline).fontWeight(.bold)
    }
}


// MARK: - Views

struct customToolBar: View {
    @State var isVisable : Bool
    @State var showDeleteButton : Bool = true
    @State var color: Color = Color(#colorLiteral(red: 0.9984468818, green: 0.2302362323, blue: 0.1865216792, alpha: 1))
    @State var firstButtonName = "Update"
   
   let firstButtonAction: () -> Void
   let deleteButtonAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                
                if isVisable {
                    
                    customToolBarButton(name: firstButtonName, systemName: "pencil",color:.green, customAction: firstButtonAction )
                    
                    Spacer()
                    
                    if showDeleteButton {
                        customToolBarButton(name: "Delete", systemName: "trash",color:.red, customAction: deleteButtonAction )
                        
                    }
                }
            }
            .frame(height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.bottom,10)
            .padding(.horizontal)
            .background(Color.white)
            
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth : .infinity, maxHeight: .infinity)
    }
}

struct customToolBarButton: View {
    var name : String
    var systemName : String
    var color: Color = Color.red
    let customAction : () -> Void
    
    var body: some View {
        Button(action: customAction ) {
            
            VStack(spacing:7) {
                
                Image(systemName: systemName)
                    .renderingMode(.template)
                    .font(.title3)
                  
                Text(name).font(.footnote)
            }  .foregroundColor(color)
            
        }
        .frame(maxWidth:.infinity)
        .padding()
        .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
        
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = self.sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}

struct textFieldWithDoneButton: View {
    @State var name : String
    @State var placeHolder : String
    @Binding var text : String
    @State var isEditing : Bool = false
    @State var trailingText : String = ""
    @State var keyBoardType :  UIKeyboardType = .default
    var body: some View {
        HStack{
            Text(name).font(.subheadline).foregroundColor(.secondary)
            Spacer()
            TextField(placeHolder, text: $text , onEditingChanged: { (changed) in
                if changed {
                    isEditing = true
                } else {
                    isEditing = false
                }
            })
            .keyboardType(keyBoardType).foregroundColor(.secondary)
            if text.count > 0 && isEditing{
                Button(action: {
                    // your action here
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    isEditing = false
                }) {
                    Text("Done").font(.body).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
            }
            Text(trailingText).font(.footnote).foregroundColor(.secondary).fontWeight(.semibold)
        }
    }
}

struct closeButtonNavBarItem: View {
    
    var customAction : () -> ()
    var body: some View {
        Button(action: {
            customAction()
        }) {
            Text("Close").foregroundColor(.red).fontWeight(.semibold)
        }
    }
}

struct buttomPlusOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .renderingMode(.original)
                    .foregroundColor(Color(#colorLiteral(red: 0.4039215686, green: 0.9450980392, blue: 0.3529411765, alpha: 1)))
                    .font(.title)
                
                
            }
        }
        .padding(.trailing,-10)
        .padding(.bottom,-10)
    }
}

struct editPlusOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "pencil.circle.fill")
                    .renderingMode(.original)
                    .foregroundColor(Color(#colorLiteral(red: 0.4039215686, green: 0.9450980392, blue: 0.3529411765, alpha: 1)))
                    .font(.title)
                
                
            }
        }
        .padding(.trailing,-10)
        .padding(.bottom,-10)
    }
}

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIView
    var style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let blurEffectView = UIView(frame: CGRect.zero)
        blurEffectView.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
        
        // Add a new `UIVibrancyEffectView` to the `contentView` of the earlier added `UIVisualEffectView`.
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
        // blurEffectView.insertSubview(vibrancyEffectView, at: 1)
        blurEffectView.insertSubview(blurView, at: 0)
        //blurEffectView.insertSubview(vibrancyEffectView, at: 1)
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: blurEffectView.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: blurEffectView.heightAnchor)
        ])
        
        return blurEffectView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
        
    }
}

struct MailView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    var subject = ""
    var body = ""
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["business.featurex@gmail.com"])
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: true)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}

struct CustomProgressView: View {
    @State var showText : Bool = false
    var body: some View {
        VStack{
            Spacer()
            VStack{
                ProgressView()
                if showText{
                    Text("One moment please").fontWeight(.bold).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(BlurView(style: .light).opacity(0.965))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Components
struct SquishableButtonStyle: ButtonStyle {
    var fadeOnPress = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed && fadeOnPress ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
        
    }
}

struct NavigationDrawerPresableButtonStyle: ButtonStyle {
    var fadeOnPress = true
    var cornerRadius : CGFloat = 15
    var color : Color = Color.red
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.subheadline.weight(.semibold))
            .frame( height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(configuration.isPressed ? color.opacity(0.1) : color.opacity(0.2))
            .foregroundColor(configuration.isPressed ?  color.opacity(0.5) : color)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            .opacity(configuration.isPressed && fadeOnPress ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// MARK: - Preview
struct swifti_Previews: PreviewProvider {
    static var previews: some View {
        swifti()
    }
}


