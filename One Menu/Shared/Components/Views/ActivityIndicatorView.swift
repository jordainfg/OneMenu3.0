//
//  ActivityIndicator.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 09/09/2020.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


struct CustomProgressView: View {
    @State var showText : Bool = false
    var body: some View {
        VStack{
            Spacer()
            VStack{
                ProgressView()
                if showText{
                    Text("One moment please").fontWeight(.bold).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(BlurView(style: .light).opacity(0.965))
        .edgesIgnoringSafeArea(.all)
    }
}
