//
//  CloseButton.swift
//  DesignCodeCourse
//
//  Created by Meng To on 2020-07-21.
//

import SwiftUI


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
