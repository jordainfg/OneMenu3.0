//
//  FirebaseService.swift
//  Nutshell
//
//  Created by Jordain Gijsbertha on 10/15/19.
//  Copyright © 2019 Jordain  Gijsbertha. All rights reserved.
//https://developers.google.com/identity/sign-in/ios/people?ver=swift

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAuth
import KeychainSwift
//import FBSDKCoreKit uncommenFacebookhere
//import FacebookCore uncommenFacebookhere
//import FacebookLogin uncommenFacebookhere
import SwiftUI

enum appState {
    case didFinishLaunchingWithOptions
    case applicationDidEnterBackground
    case applicationDidBecomeActive
    case applicationWillTerminate
    case applicationIsAuthenticatingWithGoogle
}

enum authenticationState {
    case isLoggedIn
    case isLoggedOut
}

class FirebaseService : NSObject {
    static let shared = FirebaseService()
    
    func start() {}
    
    var db : Firestore?
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var userData : User?
    
    let keychain = KeychainSwift()
    
    let authenticationStateKeyChainKey = ""
    
    var authState : authenticationState = .isLoggedOut
    
    var loginWithFacebookFailed = false
    
    
    //@AppStorage("isStarterUser") var isStarterUser: Bool = false
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    
    func configure(){
        FirebaseApp.configure()
        db = Firestore.firestore()
        
        
        
          Auth.auth().signInAnonymously() { (authResult, error) in
            // ...
        
          }
        
        //By using a listener, you ensure that the Auth object isn't in an intermediate state—such as initialization—when you get the current user. https://firebase.google.com/docs/auth/ios/manage-users
        Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
        Messaging.messaging().subscribe(toTopic: "test") { error in
          print("Subscribed to weather topic")
        }
    }
    
    
    public private(set) var authenticationState: AuthenticationState? {
        set {
            // save to the keychain
            if let state = newValue, let archived = try? PropertyListEncoder().encode(state) {
                keychain.set(archived, forKey: authenticationStateKeyChainKey)
            } else {
                keychain.delete(authenticationStateKeyChainKey)
            }
        }
        
        get {
            if
                let data = keychain.getData(authenticationStateKeyChainKey),
                let state = try? PropertyListDecoder().decode(AuthenticationState.self, from: data) {
                return state
            }
            return nil
        }
    }
    
    
    // MARK: - Create FIRUser and User Document in FIRE
    //Creates a user in the database and authentication Pane
    func createUser(withEmail: String, password: String , completionHandler: @escaping (Result<User, CoreError>) -> Void){
        Auth.auth().createUser(withEmail: withEmail, password: password) { (authResult, error) in
            if let authResult = authResult{
                // Add a new document with a your own ids
                self.userData? = authResult.user
                self.createUserDocument(user: authResult.user){_ in }
                //
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    // ...
                }
                completionHandler(.success(authResult.user))
            }
            else if error != nil{
                print(error!)
                completionHandler(.failure(.unAuthenticated))
            }
            
        }
        
    }
    
    func createUserDocument(user : User, completionHandler: @escaping (Result<Dictionary<String, Any>, CoreError>) -> Void){
        var newUser : [String : Any]?
        if let userName = user.displayName {
            if let email = user.providerData[0].email{
                newUser = ["name": "\(userName)",
                           "email": "\(email)",
                           "user_ID": "\(user.uid)",
                           "isAdmin" : false]
            }}
        else {
            if let email = user.email{
                newUser = [
                    "name": "\(email)",
                    "email": "\(user.email!)",
                    "user_ID": "\(user.uid)",
                    "isAdmin" : false
                ]
            }
        }
        if let newUserCreated = newUser{
            self.db?.collection("Users").document(user.uid).setData(newUserCreated) { err in
                if let err = err {
                    completionHandler(.failure(.error(error: err)))
                } else{
                    self.authenticationState = AuthenticationState(dictionary: newUserCreated)
                    completionHandler(.success(newUserCreated))
                }
                
            }
            
        } else{
            completionHandler(.failure(.failed(reason: "Sign in with Apple failed")))
        }
        
        
    }
    
    
    
    // MARK: - Login User
    func loginUser(Email: String, password: String, completionHandler: @escaping (Result<User, CoreError>) -> Void){
        Auth.auth().signIn(withEmail: Email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if let authResult = authResult{
                Auth.auth().addStateDidChangeListener { (auth, user) in
                    if let user = user {
                        
                        self?.setAuthenticationState(user: user){_ in }
                        self?.setAuthState(state: .isLoggedIn)
                        self?.userData = user
                        
                        completionHandler(.success(authResult.user))
                        
                    } else{
                        completionHandler(.failure(.badURL))
                        self?.clearAllSessionData()
                    }
                }
            }
            else if error != nil{
                
                completionHandler(.failure(.unAuthenticated))
            }
        }
    }
    // MARK: - Password reset mail
    func sendPasswordResetEmail(email: String,completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completionHandler(.failure(error as! CoreError))
            } else{
                completionHandler(.success(.documentAdded))
            }
            
        }
    }
    
    
    func setAuthenticationState(user : User, completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        let docRef = db?.collection("Users").document(user.uid)
        
        docRef?.getDocument { (document, error) in
            if let document = document, document.exists { // CHECK IF USER EXISTS IN FIREBASE DATABASE (IN THIS CASE THE USER HAS LOGGED IN BEFORE)
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                if let data = document.data(){
                    self.authenticationState = AuthenticationState(dictionary: data)
                    self.setAuthState(state: .isLoggedIn)
                    UserDefaults.standard.set(self.authenticationState?.isAdmin, forKey: "isAdmin")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    completionHandler(.success(.documentAdded))
                }
                print("Document data: \(dataDescription)")
            } else {
                self.createUserDocument(user: user){ (result : Result<Dictionary<String, Any>, CoreError>) in // FIRST TIME LOGGING IN CREATE NEW USER IN DATABASE
                    switch result {
                    case let .success(user):
                        self.setAuthState(state: .isLoggedIn)
                        self.authenticationState = AuthenticationState(dictionary: user)
                        UserDefaults.standard.set(self.authenticationState?.isAdmin, forKey: "isAdmin")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        completionHandler(.success(.documentAdded))
                    case .failure(_):
                        self.setAuthState(state: .isLoggedOut)
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    func setAuthState(state : authenticationState){
        self.authState = state
    }
    
    func checkAuthenticationState(){
        if authenticationState == nil {
            setAuthState(state: .isLoggedOut)
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } else {
            setAuthState(state: .isLoggedIn)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
    
    func clearAllSessionData(){
        authenticationState = nil
        setAuthState(state: .isLoggedOut)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out with facebook: %@", signOutError)
            print ("Error signing out: %@", signOutError)
        }
        // GIDSignIn.sharedInstance().signOut()
        //AccessToken.current = nil uncommenFacebookhere
        
    }
    
    // MARK: - Google Login
    //    @available(iOS 9.0, *)
    //    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    //        -> Bool {
    //            return GIDSignIn.sharedInstance().handle(url)
    //    }
    
    

    
    
}

//Bottom page 1
//        if authState == .isLoggedOut {
//            Auth.auth().signInAnonymously() { (authResult, error) in
//                if authResult != nil{
//                    print("Signed in anonymously")
//                }
//                else if error != nil{
//                    print("Error singin in anonymously")
//
//                }
//            }
//        }

//// MARK: - Facebook Login
//func loginWithFacebook(credential : AuthCredential,completionHandler: @escaping (Result<User, CoreError>) -> Void){
//    
//    // ...
//    Auth.auth().signIn(with: credential) { (authResult, error) in
//        if authResult != nil{
//            Auth.auth().addStateDidChangeListener { (auth, user) in
//                if let user = user {
//                    
//                    self.setAuthenticationState(user: user){result in
//                        switch result {
//                        case .success:
//                            self.setAuthState(state: .isLoggedIn)
//                            self.userData = user
//                            completionHandler(.success(user))
//                        case .failure:
//                            completionHandler(.failure(.failed(reason: "Facebook Sign in unsuccesfull")))
//                        }
//                    }
//                    
//                    
//                } else{
//                    completionHandler(.failure(.unknown))
//                }
//            }
//        }
//        else if error != nil{
//            print("Faccebook Sign In unsuccesful error : \(String(describing: error))")
//            self.clearAllSessionData()
//            completionHandler(.failure(.failed(reason: "Facebook Sign in unsuccesfull")))
//        }
//    }
//}
