//
//  LoginView.swift
//  Paradise Scrap
//
//  Created by Jordain Gijsbertha on 17/11/2020.
//

import SwiftUI
//import FacebookLogin uncommenFacebookhere
import Firebase
enum viewState {
    case didApear
    case isLoading
    case noDataAvailable
    case dataAvailable
    case dataAvailableButStillLoadingImages
    case tryagain
    
}

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isFocused = false
    @State var showAlert = false
    @State var alertMessage = "Something went wrong."
    @State var isLoading = false
    @State var isSuccess = false
    @State var selection : Int?
    
   // @State  var fbLoginButton = FBLoginButton() uncommenFacebookhere
    
    @State var didPressCreateAcount = false
    @State var didPressResetPassword = false

    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("loginWithFacebookFailed") var loginWithFacebookFailed: Bool = false
    
    @State var  viewState : viewState = .didApear
    var body: some View {
        ZStack{
            content
            if isLoading {
                CustomProgressView()
            }
        }.onAppear{
            print(screen.size.height)
        }
    }
    
    var content: some View {
        VStack {
            
            CoverView()
            
            VStack(spacing:10) {
                
                // MARK: - TextField Rounded Card Section
                Group{
                    VStack {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .renderingMode(.template)
                                .font(.system(size: 22, weight: .regular, design: .rounded))
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.3923175335, blue: 0.3252670169, alpha: 1)))
                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                .padding(.leading,30)
                            
                            
                            TextField("Email", text: $email, onCommit: {
                                //Called when the user taps return
                                withAnimation {
                                    isFocused = false
                                }
                            }).font(.system(size: 16, weight: .regular, design: .rounded))
                            
                            .keyboardType(.emailAddress)
                            .font(.subheadline)
                            .padding(.leading)
                            .frame(height: 44)
                            .onTapGesture {
                                withAnimation {
                                    self.isFocused = true
                                }
                            }
                        }
                        
                        Divider().padding(.leading, 80)
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .renderingMode(.template)
                                .font(.system(size: 22, weight: .regular, design: .rounded))
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.3969940543, blue: 0.3295488954, alpha: 1)))
                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                .padding(.leading,30)
                            
                            SecureField("Password", text: $password){
                                //Called when the user taps return
                                withAnimation {
                                    isFocused = false
                                }
                            }
                            .keyboardType(.default)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .padding(.leading)
                            .frame(height: 44)
                            .onTapGesture {
                                withAnimation {
                                    self.isFocused = true
                                }
                            }
                            
                        }
                    }
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .background(BlurView(style: .systemMaterial))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
                    .padding(.horizontal,30)
                }
                
                // MARK: - Sign in button and reset password
                Group{
                    HStack  {
                        
                        Button(action: {
                            didPressResetPassword = true
                        }) {
                            HStack{
                                Text("Forgot password?")
                                    .font(.system(size: 12))
                                    .underline()
                                    .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                                    .padding(.horizontal)
                            }.frame(height:30)
                            
                        } .sheet(isPresented: $didPressResetPassword, content: {
                            ResetPasswordView()
                        })
                        
                        
                        Spacer()
                        
                        Button(action: {
                            self.login()
                        }) {
                            HStack{
                                Text("Log in")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                
                            }.frame(maxWidth: .infinity)
                        }
                        .frame(width: 130)
                        .frame(maxHeight: 15)
                        .padding(12)
                        .background(Color(email.isValidEmail()  && password.count > 5 ? #colorLiteral(red: 0.2901960784, green: 0.1882352941, blue: 0.7137254902, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) ))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color(email.isValidEmail()  && password.count > 5 ? #colorLiteral(red: 0.2901960784, green: 0.1882352941, blue: 0.7137254902, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) ).opacity(0.2), radius: 20, x: 0, y: 20)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Whoops"), message:
                                    Text(self.alertMessage), dismissButton:
                                        .default(Text("OK")))
                        }
                        .disabled(email.isValidEmail()  && password.count > 5 ? false : true)
                        
                    }
                    .padding(.horizontal,30)
                    .padding(.top,10)
                    
                    Button(action: {
                        didPressCreateAcount = true
                    }) {
                        HStack {
                            Text("Don't have an acount?")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.trailing)
                            Text("Sign up")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .sheet(isPresented: $didPressCreateAcount, content: {
                        CreateUserView()
                    })
                    
                    // MARK: - Divider
                    if screen.height > 600{
                        
                        HStack {
                            VStack {
                                Divider().padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                            Text("or")
                                .font(.system(size: 12))
                            
                            VStack {
                                Divider().padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal,30)
                        
                    }
                }
                
                // MARK: - Sign in with apple
                VStack(spacing: 15){
                    SignInWithAppleToFirebase({ response in
                        if response == .success {
                           // selection = 0
                            print("logged into Firebase through Apple!")
                            
                        } else if response == .error {
                            print("failed to sign in with apple:  \(response)")
                            alertMessage = "Sign in with apple failed. Please try again later."
                            showAlert = true
                            isLoading = false
                        }
                    })
                    .frame(height : isCompact ? 40 : 50)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .padding(.horizontal,30)
                    .scaleEffect(isFocused ? 0 : 1)
                    .offset(y: isFocused ? screen.height : 0)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message:
                                Text(self.alertMessage), dismissButton:
                                    .default(Text("OK")))
                        
                    }.onTapGesture {
                        isLoading = true
                    }
                    
//                    // MARK: - Sign in with Facebook - uncommenFacebookhere
//                    Button(action: {
//                        isLoading = true
//                        fbLoginButton.sendActions(for: UIControl.Event.touchUpInside)
//
//
//                    }) {
//                        facebookLoginButtonView(button: $fbLoginButton, selection: $selection)
//                    }
//                    .scaleEffect(isFocused ? 0 : 1)
//                    .offset(y: isFocused ? screen.height : 0)
//                    .alert(isPresented: $loginWithFacebookFailed) { () -> Alert in
//                        let dismissButton = Alert.Button.default(Text("Okay")) {
//                            isLoading = false
//                        }
//                        return Alert(title: Text("Whoops"), message: Text("We couldn't login you in with facebook. Please try signing in with Apple"), dismissButton: dismissButton)
//                    }
                    
                    
                    //MARK: - Google Login
//                    Button(action: {
//                        self.loginWithGoogle()
//                    }) {
//                        HStack {
//                            Image(uiImage: #imageLiteral(resourceName: "icGoogleCircle"))
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(.white)
//
//                            Text("Continue with Google")
//                                .font(.system(size: 16, weight: .semibold, design: .rounded))
//                                .foregroundColor(.white)
//                                .multilineTextAlignment(.trailing)
//                        }
//                        .frame(maxWidth: .infinity)
//
//                    }
//
//                    .buttonStyle(roundedButtonStyle(color: Color(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)), shadowColor:Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))))
//                    .scaleEffect(isFocused ? 0 : 1)
//                    .offset(y: isFocused ? screen.height : 0)
//                    .alert(isPresented: $showAlert) {
//                        Alert(title: Text("Error"), message:
//                                Text(self.alertMessage), dismissButton:
//                                    .default(Text("Okay")))
//                    }
                    if screen.height > 700{
                        Spacer()
                    }
                }
                
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .padding(.top, isCompact ? -90 : -62)
            
            
        }
        .edgesIgnoringSafeArea(.top)
        .offset(y: isFocused ? 0 : 0)
        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
        .onTapGesture {
            withAnimation {
                self.isFocused = false
                self.hideKeyboard()
            }
        }
        
    }
    
    // MARK: - Functions
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func login(){
        //self.showAlert = true
        self.hideKeyboard()
        self.isFocused = false
        self.isLoading = true
        self.isSuccess = true
        
        
        FirebaseService.shared.loginUser(Email: email, password: password) { (result : Result<User, CoreError>) in
            switch result {
            case .success:
                selection = 0
               
            case .failure:
                alertMessage = "The combination of this user name and password is invalid. Please try again or reset your password."
                showAlert = true
                self.isLoading = false
            }
        }
        //delay
        
        
    }
    func loginWithApple(){
        
    }
    
    
    func loginWithFacebook(){
        // https://firebase.google.com/docs/auth/ios/facebook-login?authuser=0 // How to add facebook login for firebase
        // https://github.com/facebook/facebook-ios-sdk // adds facebook to swift packages
        // Config for facebook developer portal: https://developers.facebook.com/docs/facebook-login/ios
        
        
    }
    func loginWithGoogle(){}
    
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environment(\.colorScheme, .light)
        // Authentication().environment(\.colorScheme, .dark)
    }
}



let screen = UIScreen.main.bounds

let isCompact = UIScreen.main.bounds.height < 700 ? true : false

struct CoverView: View {
    @State var viewState = CGSize.zero
   
    var body: some View {
        VStack {
        
            VStack(spacing: 5) {
                Image("appLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    .frame(width: isCompact ? 40 : 70, height: isCompact ? 40 : 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.top)
                Text("One Menu Business").font(.system(size: isCompact ? 20 : 33, weight: .bold, design: .default)).multilineTextAlignment(.center).padding(.top,10)
                Text("The tools you need to take a modern approach for your restaurant's  menu.").font(.system(size: isCompact ? 12 : 16, weight: .semibold, design: .default)).foregroundColor(.secondary).padding(.horizontal,40)
                Spacer()
            }.frame(maxHeight : .infinity).padding(.top,isCompact ? 40 : 60)
        }
        .multilineTextAlignment(.center) // this
        .frame(height: isCompact ? 250 : 360)
        .frame(maxWidth : .infinity)
        .background(Image("foodWall")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(1.7))
        .background(Color("grouped"))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}
