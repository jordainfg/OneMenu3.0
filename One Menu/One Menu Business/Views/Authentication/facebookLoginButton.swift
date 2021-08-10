////
////  ContentView.swift
////  Paradise Scrap
////
////  Created by Jordain Gijsbertha on 17/11/2020.
////
///t
///his is a working Implentation un comment here and in LoginView.swift !!!!!!!!! uncommenFacebookhere
//





//import SwiftUI
//import FacebookLogin
//import Firebase
//
//struct facebookLoginButtonView: View {
//    @Binding var  button : FBLoginButton
//    @Binding var selection : Int?
//
//    var body: some View {
//        facebookLoginButton(selection: $selection, button: button)
//            .frame(height : 40)
//            .opacity(0).overlay(
//                HStack {
//                    Image(uiImage: #imageLiteral(resourceName: "icFacebook"))
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 25, height: 25)
//                        .foregroundColor(.white)
//
//                    Text("Continue with Facebook")
//                        .foregroundColor(.white)
//                        .font(.system(size: 16, weight: .semibold, design: .rounded))
//                        .multilineTextAlignment(.trailing)
//                }
//                .frame(maxWidth: .infinity)
//            )
//            .frame(height: isCompact ? 40 : 50)
//            .background(Color(#colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1)))
//            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
//            .shadow(color: Color(#colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
//            .padding(.horizontal,30)
//    }
//}
//
//
//
//// MARK: - Facebook Login Button
////struct facebookLoginButton : UIViewRepresentable{
////
////    @Binding var selection : Int?
////
////    let button : FBLoginButton
////
////
////    func facebookloginSuccessful(selection : Int){
////
////            self.selection = 0
////
////
////    }
////
////    func makeCoordinator() -> facebookLoginButton.Coordinator {
////        return facebookLoginButton.Coordinator(parent1: self)
////    }
////
////
////    func makeUIView(context: UIViewRepresentableContext<facebookLoginButton>) -> FBLoginButton{
////
////
////        button.permissions = ["public_profile", "email"]
////        button.delegate = context.coordinator
////
////        return button
////    }
////
////    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<facebookLoginButton>) {
////
////    }
////
////    class Coordinator : NSObject,LoginButtonDelegate{
////
////        var parent : facebookLoginButton
////
////
////
////        init (parent1: facebookLoginButton){
////            parent = parent1
////        }
////
////
////        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
////            if result?.isCancelled ?? false {
////                UserDefaults.standard.set(true, forKey: "loginWithFacebookFailed")
////                    }
////            if error != nil{
////                UserDefaults.standard.set(true, forKey: "loginWithFacebookFailed")
////                print((error?.localizedDescription)!)
////                return
////            }
////
////            if AccessToken.current != nil {
////                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
////
////                Auth.auth().signIn(with: credential) { (authResult, error) in
////                    if authResult != nil{
////                        Auth.auth().addStateDidChangeListener { (auth, user) in
////                            if let user = user {
////                                FirebaseService.shared.setAuthenticationState(user: user){result in
////                                                     switch result {
////                                                     case .success:
////                                                        self.parent.facebookloginSuccessful(selection : 0)
////                                                                                  FirebaseService.shared.authState = .isLoggedIn
////                                                                                  FirebaseService.shared.userData = user
////                                                     case .failure:
////                                                        UserDefaults.standard.set(true, forKey: "loginWithFacebookFailed")
////                                                        FirebaseService.shared.authState = .isLoggedOut
////                                                        FirebaseService.shared.clearAllSessionData()
////                                                     }
////                                                 }
////
////
////                            } else{
////                                UserDefaults.standard.set(true, forKey: "loginWithFacebookFailed")
////                            }
////                        }
////                    }
////                    else if error != nil{
////                        print("Faccebook Sign In unsuccesful error : \(String(describing: error))")
////                        UserDefaults.standard.set(true, forKey: "loginWithFacebookFailed")
////                        FirebaseService.shared.authState = .isLoggedOut
////                        FirebaseService.shared.clearAllSessionData()
////                    }
////                }
////            }
////        }
////
////        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
////            FirebaseService.shared.clearAllSessionData()
////        }
////
////
////    }
////
////}
//
//
//
