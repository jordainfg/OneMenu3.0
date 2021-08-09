//
//  OnBoarding.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 10/10/2020.
//

import SwiftUI

struct OnBoarding: View {
    @ObservedObject var store : DataStore
   
    @State var showingFormSheet = false
    @State var showsFormButton = false
    @State var isDone = false
    @Environment(\.presentationMode) var presentationMode
    @State var index: Int = 0
    var body: some View {
        
        
        VStack {


            if index == 0 {
                OnBoardingArticle(image: Image(uiImage: #imageLiteral(resourceName: "onBoardingImageThree")),title:"pageOneTitle",paragraph: "pageOneBody")
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.4)))
            } else if index == 1{
                OnBoardingArticle(image: Image(uiImage: #imageLiteral(resourceName: "onBoardingUpdate")),title:"pageTwoTitle",paragraph: "pageTwoBody")
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.4)))
            }
            else if index > 1 {
                OnBoardingArticle(image: Image(uiImage: #imageLiteral(resourceName: "onBoardingImprovement")),title:"pageThreeTitle",paragraph: "pageThreeBody")
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.4)))
            }
            

            Spacer()
            if !showsFormButton{
            HStack(spacing: 20) {

                Button(action: {

                    if index > 1{
                        index = 0
                        isDone = false
                    } else {
                        index -= 1
                    }

                }, label: {
                    HStack{
                        Spacer()
                        Text(isDone ?  "Cancel" : "Previous").font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary)
                        Spacer()
                    }
                })
                .buttonStyle(NavigationDrawerPresableButtonStyle(color: Color.gray.opacity(0.2)))
                .opacity(index > 0 ? 1 : 0)
                .animation(.easeInOut)
                Button(action: {
                    index += 1

                    if index > 2 {

                        self.showingFormSheet = true
                        isDone = true
                    }
                    else if index > 1{

                        isDone = true

                    } else {
                       // index += 1
                    }


                }, label: {
                    HStack{
                        Spacer()
                        Text(isDone ?  "StartRequest" : "Continue").font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                        Spacer()
                    }
                })
                .buttonStyle(NavigationDrawerPresableButtonStyle(color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))))

            }
            .padding(.horizontal,30)
            .padding(.top)
            .padding(.bottom)
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.4)))
            }

        }
        .sheet(isPresented: $showingFormSheet,onDismiss: { index = 0
                isDone = false } ) {
            OneMenuBusiness()
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.4)))
                }
        .navigationBarTitle("Digitalize your menu", displayMode: .inline)
        .animation(.none)


        

        

        }

//
            
}
            
    
    



struct OnBoardingArticle: View {
    var image : Image = Image(uiImage: #imageLiteral(resourceName: "3593987"))
    var title : String = ""
    var paragraph : String = ""
    var body: some View {
        
        VStack(spacing:10){
            image
                .resizable()
                .aspectRatio(contentMode: .fit).padding(.top)
                
            Text(LocalizedStringKey(title))
                .font(.body).fontWeight(.bold).padding(.vertical,10).multilineTextAlignment(.center)
            Text(LocalizedStringKey(paragraph))
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom)
            
        }.padding()
        
    }
}
