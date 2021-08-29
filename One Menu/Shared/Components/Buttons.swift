//
//  Buttons.swift
//  Buttons
//
//  Created by Jordain on 29/08/2021.
//

import Foundation
import SwiftUI

struct BottomBarButton: View {
   
    var name : String
    var systemName : String
    var aditionalText : String
    var color : Color = Color.black
    var customAction: () -> ()
    var body: some View {
        
        
        VStack {
            Button(action: customAction
                   , label: {
                HStack {
                    Label(name, systemImage: systemName)
                    Text(aditionalText).foregroundColor(Color("whiteToBlack").opacity(0.5))
                }
            })
            .buttonStyle(VibrantActionButtonStyle())
            .padding(10)
            .padding(.bottom,30)
        }
        .background(VisualEffectBlur(blurStyle: .regular))
        .frame(maxWidth:.infinity)
            .offset(x: 0, y: 40)
    }
}

struct VibrantActionButtonStyle: ButtonStyle {
    var fadeOnPress = true
    var cornerRadius : CGFloat = 15
    var color : Color = Color.red
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.subheadline.weight(.semibold))
            .frame( height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color("BlackToWhite"))
            .foregroundColor(Color("whiteToBlack"))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            .opacity(configuration.isPressed && fadeOnPress ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct LoveButton: View {
    @Binding var isSelected : Bool
    
    var name : String = ""
    var iconName : String = ""
    var color : Color = Color.red
    var customAction: () -> ()
    var body: some View {
        
        Button(action: {
            customAction()
            withAnimation{
                self.isSelected.toggle()
            }
            
        }, label: {
            if isSelected{
                Image(systemName: "heart")
                    .font(.title2)
                    .foregroundColor(Color.red)
            } else {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(Color.red)
            }
           
        })
        
    }
}

struct SquareButton: View {
    var name : String = ""
    var image : String = ""
    var customAction: () -> ()
    var body: some View {
        
        Button(action: {
            customAction()
            
        }, label: {
            
            VStack {
                VStack(spacing:10) {
                    Image(image)
                        .foregroundColor(.white)
                    .font(.largeTitle)
                    Text(name)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
                .padding(.vertical)
                
            }
            .frame(maxWidth: .infinity)
            .background(Color(hexString: "#2D2E33"))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        })
    }
}


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



struct roundedButtonStyle: ButtonStyle {
    
    let color : UIColor
    let shadowColor : UIColor
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color(color))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(color: Color(shadowColor).opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal,30)
    }
}

struct CloseButton: View {
    
    var customAction: () -> ()
    var body: some View {
        Button(action: {
            customAction()
        }, label: {
        Image(systemName: "xmark")
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .padding(.all, 10)
            .background(Color.black.opacity(0.6))
            .clipShape(Circle())
        })
    }
}



struct NavigationDrawerButton: View {
    @Binding var isSelected : Bool
    
    var name : String = ""
    var iconName : String = ""
    var color : Color = Color.red
    var customAction: () -> ()
    var body: some View {
        
        Button(action: {
            customAction()
            self.isSelected = true
        }, label: {
            HStack(spacing: 10){
                    HStack(spacing: 10){
                    Image(systemName: iconName)
                        .renderingMode(.template)
                        .font(.body)
                        .foregroundColor(isSelected ?  color : .secondary )
                        Text(LocalizedStringKey(name)).foregroundColor(isSelected ?  color : .secondary ).font(Font.subheadline.weight(isSelected ? .semibold : .regular))
                    Spacer()
                    }.padding()
            }
            .frame( height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(isSelected ? color.opacity(0.2) : Color.white.opacity(0.0000001))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        })
        
    }
}

struct NavigationDrawerUserButton: View {
    var name : String = ""
    var image : String = ""
    var customAction: () -> ()
    var body: some View {
        
        Button(action: {
            customAction()
            
        }, label: {
            VStack {
                HStack(alignment: .center, spacing:15){
                    Image(image)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 60, height: 60)
                    
                    VStack(alignment: .leading,spacing: 3){
                        Text("Acount").font(.headline).fontWeight(.bold).foregroundColor(.primary)
                        Text(name).font(.subheadline).fontWeight(.semibold).foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            .padding(.bottom)
        })
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
