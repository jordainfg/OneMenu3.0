////
////  StrechyFirebaseStorageImageHeader.swift
////  StrechyFirebaseStorageImageHeader
////
////  Created by Jordain on 30/08/2021.
////
//
//import SwiftUI
//import SDWebImageSwiftUI
//import Firebase
//
//struct StrechyFirebaseStorageImageHeader : View{
//    
//    @State var firestoreLocationUrlString : String
//    
//    @State var image : WebImage?
//    
//    @ObservedObject var store : DataStore
//    
//    
//    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
//        geometry.frame(in: .global).minY
//    }
//    
//    // 2
//    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
//        let offset = getScrollOffset(geometry)
//        
//        // Image was pulled down
//        if offset > 0 {
//            return -offset
//        }
//        
//        return 0
//    }
//    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
//        let offset = getScrollOffset(geometry)
//        let imageHeight = geometry.size.height
//        
//        if offset > 0 {
//            return imageHeight + offset
//        }
//
//        return imageHeight
//    }
//    
//    func retrieveImageFromFirebaseStorage(){
//        if !firestoreLocationUrlString.hasPrefix("gs://") {
//            firestoreLocationUrlString = "gs://one-menu-40f52.appspot.com/Assets/placeHolderForOneMenuDark@3x.png"
//        }
//        let storageRef = store.storage.reference(forURL: firestoreLocationUrlString)
//        storageRef.downloadURL { url, error in
//            if let error = error {
//                print(error.localizedDescription)
//                image = WebImage(url: URL(string:""))
//                
//            } else {
//                if let url = url {
//                    image = WebImage(url: url)
//                    print("Got image for StrechyFirebaseStorageImageHeader")
//                   
//                }
//            }
//            
//        }
//    }
//    
//    var body : some View{
//        VStack(alignment:.center){
//            ZStack(alignment:.top){
//                GeometryReader { geometry in
//                    if let image = image{
//                        image
//                            .placeholder {PlaceholderImage() }
//                            .resizable()
//                            .background(Color("grouped"))
//                            .scaledToFill()
//                            .overlay(TintOverlay().opacity(0.4))
//                            .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
//                            .cornerRadius(20, corners: [.bottomLeft,.bottomRight])
//                            .clipped()
//                            .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
//                    }
//                }
//                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//                .frame(height:screen.height/4 , alignment: .topLeading)
//                .shadow(color: Color.primary.opacity(0.2), radius: 20, x: 0, y: 10)
//                
//            }
//        }
//        .edgesIgnoringSafeArea(.top)
//        .onLoad(perform: {retrieveImageFromFirebaseStorage()})
//    }
//}
//
//struct StrechyFirebaseStorageImageHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        StrechyFirebaseStorageImageHeader(firestoreLocationUrlString: "gs://one-menu-40f52.appspot.com/Assets/placeHolderForOneMenuDark@3x.png", store: DataStore())
//    }
//}
//
//
//
//struct PlaceholderImage: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "photo")
//                .resizable()
//                .renderingMode(.template)
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 60, height: 60)
//                .foregroundColor(Color.white)
//        }
//        .frame(maxWidth:.infinity, maxHeight: .infinity)
//        .background(Color("grouped"))
//    }
//}
