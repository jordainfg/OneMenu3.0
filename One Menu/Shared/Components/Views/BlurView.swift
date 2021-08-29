//
//  BlurView.swift
//  BlurView
//
//  Created by Jordain on 29/08/2021.
//

import SwiftUI
struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIView
    var style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let blurEffectView = UIView(frame: CGRect.zero)
        blurEffectView.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
        
        // Add a new `UIVibrancyEffectView` to the `contentView` of the earlier added `UIVisualEffectView`.
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
        // blurEffectView.insertSubview(vibrancyEffectView, at: 1)
        blurEffectView.insertSubview(blurView, at: 0)
        //blurEffectView.insertSubview(vibrancyEffectView, at: 1)
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: blurEffectView.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: blurEffectView.heightAnchor)
        ])
        
        return blurEffectView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
        
    }
}
