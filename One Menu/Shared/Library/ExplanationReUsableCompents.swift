//
//  CloseButton.swift
//  DesignCodeCourse
//
//  Created by Meng To on 2020-07-21.
//

import SwiftUI

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

// MARK: - ViewBuilder and ViewModifier help us create reusable components

/*
1. Creating a BaseView – A view has common UI elements, layout helpers and utility functions like setting a background image, adding a tab bar, setting navigation bar title, alerts, loading indicators – all in one place. Any other SwiftUI views should inherit the properties from BaseView.

2. Reusing UI components that are consistent across the app.
*/

      // MARK: -  SwiftUI can help us with this with the powerful ViewModifier. LetText be an example.

        struct TextModifier: ViewModifier {
            let color: Color
            func body(content: Content) -> some View {
                content
                  .font(Font.largeTitle.weight(.heavy))
                  .fixedSize(horizontal: false, vertical: true)
                  .foregroundColor(color)
                  .multilineTextAlignment(.center)
                  .lineLimit(nil)
            }
        }

     // MARK: - ViewModifier example
     // For any view that needs to use this custom modifier, just embed it as follows:

        struct ViewModifierExample: View {
            var body: some View {
                Text("iosAppTemplates.com")
                    .modifier(TextModifier(color: .red))
            }
        }

     /*
     Boom! You can now simply apply this text modifier to any custom view that you are using in your app, to apply the same colors, line limits, and size customizations, with only one line of code.
     */


// MARK: - ViewBuilder
    /*
    A mobile application usually has a consistent design – for example, the logo might appear at the top of the screen, all the screens have the same background color and so on. But content can vary drastically. To avoid duplication, we will create a BaseView
    */

        struct BaseView<Content: View>: View {
            
            let content: Content
            
            init(@ViewBuilder content: () -> Content) {
                self.content = content()
            }
            
            var body: some View {
                // In here we put the common UI elements
                VStack(alignment: .center, spacing: 25) {
                    HStack {
                       Image("Logo3")
                     }.padding(.top, 60)
                     Spacer()
                     content
                     Spacer()
                     Text("iOS App Templates")
                     
                }
            }
        }

    // MARK: - ViewBuilder example

        struct viewBuilderExample: View {
            var body: some View {
                BaseView() {
                    Text("Here you can put extra's. Think about viewbuilder as an stock car. Add that you can reuse that stock car in mutiple places but for each car you can add custom parts, like a spoiler or extra exhaust etc. Another word for it is a wrapper.").font(.body).fontWeight(.semibold).multilineTextAlignment(.center)
                }
            }
        }


    // MARK: - Conclusion
    /*
         With these two extremely powerful tools, we were able to reuse components and be able to build a BaseView foundation class similarly to how we used to do it in UIKit. The simplicity of SwiftUI and the intense focus on the UI layer can be a trap to iOS developers, since it’s very tempting now to violate SOLID principles and use bad practices, just because these are quick.

         It’s important for SwiftUI programmers to get familiar with concepts such as ViewBuilder and ViewModifier, so that their code stays clean and nice, making it it easy to maintain and reuse big codebases in the long-term.
     
     */

struct ExplanationReUsableCompents_Previews: PreviewProvider {
    static var previews: some View {
        viewBuilderExample()
        ViewModifierExample()
    }
}
