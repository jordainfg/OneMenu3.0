//
//  LandingPage.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 19/08/2020.
//

import SwiftUI

struct LandingPage: View {
    @State var isDone = true
    @Binding var showLandingPageModal: Bool
    @State var index: Int = 0
    var body: some View {
        VStack {
            
            HStack{
                Spacer()
            Button(action: {
                
                self.showLandingPageModal.toggle()
            }, label: {
                Text(isDone ? "Done" : "")
                        .font(.headline)
                        .fontWeight(.semibold)
                    .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                    .padding()
            })
            }

            if index == 0 {
                Welcome().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
            } else if index == 1{
                Features().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
            }
            else if index == 2{
                HowItWorks().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))//
                    .onAppear{
                        isDone = false
                    }.onDisappear{
                        isDone = true
                    }
            }
            
                
            
              
            Button(action: {
                index += 1
                
                if index > 2{
                    showLandingPageModal = false
                }
            }, label: {
                HStack{
                    Spacer()
                    Text(isDone ? "Continue" : "Done").font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
            })
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("accentToBlack"))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 0.9882352941, green: 0.4470588235, blue: 0.3843137255, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: CGFloat(0))
            .padding(.horizontal,30)
            .padding(.bottom,30)
            
            
     //}
            
         
           
        }
        .background(Color("grouped"))
        .edgesIgnoringSafeArea(.bottom)
            
        }
            
    
}

//struct LandingPage_Previews: PreviewProvider {
//    static var previews: some View {
//        LandingPage()
//    }
//}

