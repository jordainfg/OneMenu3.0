//
//  LottieView.swift
//  DesignCodeCourseOne
//
//  Created by Jordain Gijsbertha on 21/07/2020.
//  Copyright © 2020 Jordain Gijsbertha. All rights reserved.
//

import SwiftUI
import Lottie
struct LottieView: UIViewRepresentable {
    @State var filename: String
    var loopMode: LottieLoopMode = .playOnce
    var animationView = AnimationView()

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()

        animationView.animation = Animation.named(filename)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        animationView.play()
    }
    func play(){
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
}
   

