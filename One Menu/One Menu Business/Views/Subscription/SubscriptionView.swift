//
//  ContentView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 20/01/2021.
//

import SwiftUI
import Purchases


enum subscriptionActiveSheet: Identifiable {
    case termsOfUse, privacyPolicy
    
    var id: Int {
        hashValue
    }
}
struct SubscriptionView: View {
    //@AppStorage("isStarterUser") var isStarterUser: Bool = false
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    @State var isLoading = false
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @Environment(\.presentationMode) var presentationMode
    @State var errorCode : Purchases.ErrorCode.Code = Purchases.ErrorCode.Code.invalidReceiptError
    
    @State var activeSheet : subscriptionActiveSheet?
    @State var alerts : alerts?
    
    var body: some View {
        ZStack{
            if isPremiumUser{
                subscribtionInfo.smoothTransition()
            } else {
                subscribeView.smoothTransition()
                
            }
            
            if isLoading {
                CustomProgressView(showText: true).smoothTransition()
            }
        }
    }
    
    var subscribtionInfo: some View {
        NavigationView{
            VStack{
                VStack(alignment:.center, spacing: 10) {
                    Image("appLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isCompact ? 40 : 70, height: isCompact ? 40 : 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(.top)
                        .padding(.horizontal)
                    if isPremiumUser{
                        Text("You're a premium user").font(.title).fontWeight(.heavy).multilineTextAlignment(.leading).padding(.horizontal).fixedSize(horizontal: false, vertical: true)
                    }
                    else {
                        Text("You're a starter user").font(.largeTitle).fontWeight(.heavy).padding().fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment:.center,spacing:20) {
                        
                        Text("You can cancel or change your plan at any time. Let us know if you have any questions.").font(.subheadline).fontWeight(.semibold).foregroundColor(.secondary).padding(.horizontal).fixedSize(horizontal: false, vertical: true).padding(.top,10)
                        
                        Text("Payments will be charghed to your iTunes account after confirmation. Subscriptions will automatically renew unless canceled within 24-hours before the end of the subscription period. You can cancel anytime with your iTunes account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription. For more information, see our terms of use and privacy. policy.").padding(.horizontal).font(.footnote).foregroundColor(.secondary)
                        
                        Link(destination: URL(string: "https://apps.apple.com/account/subscriptions")!) {
                            Text("Manage your subscription").foregroundColor(Color(#colorLiteral(red: 1, green: 0.4335931838, blue: 0.377388984, alpha: 1))).font(.headline).padding(.horizontal)
                        }.padding(.bottom,10)
                        
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                    .background(Color("grouped"))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.horizontal)
                    
                    
                    
                    VStack(alignment:.leading) {
                        SettingsOptionButton(settingName: "Contact us", settingIconSystemName: "phone.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.4335931838, blue: 0.377388984, alpha: 1)){
                          
                           guard let instagram = URL(string: "https://wa.me/message/LQGXHL7RCFN6D1") else { return }
                            UIApplication.shared.open(instagram)
                            
                        }.padding()
                    }
                    .background(Color("grouped"))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.horizontal)
                    Spacer()
                    
                }
                .frame(maxHeight : .infinity).padding(.top,30)
                
                
                
                
            }
            .navigationBarTitle("Subscription",displayMode: .inline)
            .navigationBarItems(trailing: closeButtonNavBarItem{presentationMode.wrappedValue.dismiss()})
            
        }
        
    }
   
    var subscribeView: some View {
        ScrollView {
            VStack {
                // MARK: - Header
                SubscriptionViewHeader()
                    
                    .padding(.vertical)
                
                // MARK: - Options
                VStack{
                    subscriptionFree(name: "Basic", features: ["One Restaurant","Two consumables and beverages"])
                    ForEach(subscriptionManager.subscriptionPlans, id: \.self){ plan in
                        
                        Button(action: {
                            isLoading = true
                            subscriptionManager.purchasePackage(plan: plan){ result in
                                switch result {
                                case let .success(result):
                                    switch result {
                                    default:
                                        
                                        alerts = .showSuccessAlert
                                    }
                                case let .failure(err):
                                    switch err.code {
                                    default:
                                        isLoading = false
                                        alerts = .showFailedAlert
                                        errorCode = err.code
                                        print(errorCode)
                                        break
                                    }
                                }
                            }
                        }, label: {
                            subscriptionPlanOptionView(subscriptionPlan: plan)
                        })
                        .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
                      
                        
                    }.smoothTransition()
                }.offset(x: 0, y: -20)
                
                // MARK: - Footer
                
                Button(action: {
                    isLoading = true
                    subscriptionManager.restorePurchases{result in
                        switch result {
                        case .success:
                            alerts  = .showSuccessAlert
                            isLoading = false
                        case .failure:
                            alerts = .showFailedAlert
                            isLoading = false
                        }
                    }
                }) {
                    Text("Restore purchases").fontWeight(.semibold).font(.subheadline).foregroundColor(.secondary)
                }
                Text("Payments will be charghed to your iTunes account after confirmation. Subscriptions will automatically renew unless canceled within 24-hours before the end of the subscription period. You can cancel anytime with your iTunes account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription. For more information, see our terms of use and privacy. policy.").multilineTextAlignment(.center).padding(.horizontal).font(.footnote).foregroundColor(.secondary).padding(.vertical,5)
                
                HStack{
                    Button(action: {
                        activeSheet = .termsOfUse
                    }) {
                        Text("Terms of use")
                    }
                    
                    Button(action: {
                        activeSheet = .privacyPolicy
                    }) {
                        Text("Privacy policy")
                    }
                }
                .sheet(item: $activeSheet){ sheet in
                    NavigationView{
                        switch sheet{
                        
                        case .termsOfUse:
                            PrivacyPolicy(isTermsofUse: true).navigationBarItems(trailing: closeButtonNavBarItem{
                                activeSheet = nil
                            })
                        case .privacyPolicy:
                            PrivacyPolicy().navigationBarItems(trailing: closeButtonNavBarItem{
                                activeSheet = nil
                            })
                        }
                    }
                }
                .buttonStyle(NavigationDrawerPresableButtonStyle(fadeOnPress: true, color: Color(#colorLiteral(red: 0.6087105274, green: 0.6033536792, blue: 0.6209080815, alpha: 1))))
                .padding(.horizontal,30)
                .padding(.vertical,5)
                .padding(.bottom)
            }
            .alert(item: $alerts){ alert in
                switch alert {
                case .showSuccessAlert:
                    return Alert(title: Text("Success"), message: Text("You're all set. You can start using One Menu Premium."), dismissButton: Alert.Button.default(
                        Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                    ))
                    
                case .showFailedAlert:
                    return  Alert(title: Text("Whoops"), message: Text("We couldn't complete/restore your purchase. Please try again."), dismissButton: Alert.Button.default(
                        Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                    ))
                    
                case .showValidationAlert:
                    return   Alert(title: Text("Whoops"), message: Text("Please fill in all required fields first."), dismissButton: Alert.Button.default(
                        Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                    ))
                case .showSubscribeAlert:
                    return   Alert(title: Text("Whoops"), message: Text("Please fill in all required fields first."), dismissButton: Alert.Button.default(
                        Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                    ))
                }
                
            }
            .onAppear{
                if subscriptionManager.subscriptionPlans.isEmpty{
                    subscriptionManager.getSubscriptions()
                }
            }
        }.background(Color("lightGroupedToBlack")).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .overlay(VStack{
            HStack{
                Spacer()
            Button(action: {
                // your action here
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .renderingMode(.template)
                    .font(.largeTitle)
                    .padding(.horizontal)
                    .padding(.top)
                    .foregroundColor(.primary)
            }
               
            }.padding(.horizontal )
            Spacer()
        }.frame(maxWidth:.infinity,maxHeight: .infinity))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}

struct SubscriptionViewHeader: View {
    @State var viewState = CGSize.zero
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            
            VStack(spacing: 10) {
                Image("appLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isCompact ? 40 : 70, height: isCompact ? 40 : 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Text("One Menu \n Subscription").font(.largeTitle).fontWeight(.heavy).multilineTextAlignment(.center).padding(.horizontal).fixedSize(horizontal: false, vertical: true)
                Text("By upgrading to a starter or premium subscription you unlock access to additional functionality for your business needs.").font(.subheadline).fontWeight(.semibold).foregroundColor(.secondary).padding(.horizontal).fixedSize(horizontal: false, vertical: true)
                Spacer()
            }.frame(maxHeight : .infinity).padding(.top,30)
            
        }
        .multilineTextAlignment(.center) // this
        //.frame(height: isCompact ? 250 : 360)
        .frame(maxWidth : .infinity)
        .background(Image("foodWall")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(1.7))
        .background(Color("grouped"))
        
    }
}

struct featureCheckMark: View {
    var title : String
    var color : Color
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
                .renderingMode(.template)
                .font(.subheadline)
                .foregroundColor(color)
            Text(title).foregroundColor(Color.secondary).font(.subheadline)
        }.padding(.horizontal)
        .padding(.vertical,5)
    }
}

struct subscriptionPlanOptionView: View {
    var subscriptionPlan : subscriptionPlanOption
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .center) {
                Text(subscriptionPlan.name).font(.title3).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color(#colorLiteral(red: 1, green: 0.4335931838, blue: 0.377388984, alpha: 1))).fixedSize(horizontal: false, vertical: true)
                Spacer()
                
                Text(subscriptionPlan.price).font(.caption).fontWeight(.semibold).foregroundColor(Color.primary) + Text(" / Month after 1 wk").font(.caption2).foregroundColor(.secondary)
                
                
            }.padding(.horizontal).padding(.top,5)
            Divider().background(Color.white)
            ForEach(subscriptionPlan.features, id: \.self) { feature in
                featureCheckMark(title: feature, color: Color(#colorLiteral(red: 1, green: 0.4335931838, blue: 0.377388984, alpha: 1)))
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth : .infinity)
        .background(Color("whiteToDarkGrouped"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
        .padding(.top,10)
        .shadow(color: Color.gray.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 10)
        .animation(.easeInOut)
        
    }
}

struct subscriptionFree: View {
    var name : String
    
    
    var features : [String]
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .center) {
                Text(name).font(.title3).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color(#colorLiteral(red: 1, green: 0.4335931838, blue: 0.377388984, alpha: 1)))
                Spacer()
                
                Text("Free").font(.caption).fontWeight(.semibold)
                
            }.padding(.horizontal).padding(.top,5)
            Divider()
            ForEach(features, id: \.self) { feature in
                featureCheckMark(title: feature, color: Color.secondary)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth : .infinity)
        .background(Color("whiteToDarkGrouped"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
        .padding(.top,10)
        .shadow(color: Color.gray.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 10)
        .animation(.easeInOut)
        
    }
}
