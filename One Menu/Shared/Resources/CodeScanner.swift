//
//  CodeScannerView.swift
//
//  Created by Paul Hudson on 10/12/2019.
//  Copyright © 2019 Paul Hudson. All rights reserved.
//

import AVFoundation
import SwiftUI
import UIKit
// MARK: - Documentation
/*
 
 1. @State private var isShowingScanner = false
 
 2.
        func handleScan(result: Result<String, CodeScannerView.ScanError>) {
           self.isShowingScanner = false
            switch result {
            case .success(let code):
               print(code)
               
            case .failure(let error):
                print("Scanning failed")
            }
        }
 
 3.
        Button()
            .onTapGesture {
                self.isShowingScanner = true
                print("test")
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
            }
 
 */
public struct CodeScannerView: UIViewControllerRepresentable {
    public enum ScanError: Error {
        case badInput, badOutput
    }

  
    public class ScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CodeScannerView
        var codeFound = false

        init(parent: CodeScannerView) {
            self.parent = parent
        }

        public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                guard codeFound == false else { return }

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)

                // make sure we only trigger scans once per use
                codeFound = true
            }
        }

        func found(code: String) {
            parent.completion(.success(code))
        }

        func didFail(reason: ScanError) {
            parent.completion(.failure(reason))
        }
    }

    #if targetEnvironment(simulator)
    public class ScannerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        var delegate: ScannerCoordinator?
        override public func loadView() {
          
            
        
            view = UIView()
            view.isUserInteractionEnabled = true
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0

            label.text = "You're running in the simulator, which means the camera isn't available. Tap anywhere to send back some simulated data."
            label.textAlignment = .center
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Or tap here to select a custom image", for: .normal)
            button.setTitleColor(UIColor.systemBlue, for: .normal)
            button.setTitleColor(UIColor.gray, for: .highlighted)
            button.addTarget(self, action: #selector(self.openGallery), for: .touchUpInside)

            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 50
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(button)

            view.addSubview(stackView)
          
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 50),
                stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        
        

        override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let simulatedData = delegate?.parent.simulatedData else {
                print("Simulated Data Not Provided!")
                return
            }

            delegate?.found(code: simulatedData)
        }

        @objc func openGallery(_ sender: UIButton){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
            if let qrcodeImg = info[.originalImage] as? UIImage {
                let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                let ciImage:CIImage=CIImage(image:qrcodeImg)!
                var qrCodeLink=""

                let features=detector.features(in: ciImage)
                for feature in features as! [CIQRCodeFeature] {
                    qrCodeLink += feature.messageString!
                }

                if qrCodeLink=="" {
                    delegate?.didFail(reason: .badOutput)
                }else{
                    delegate?.found(code: qrCodeLink)
                }
            }
            else{
                print("Something went wrong")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    #else
    public class ScannerViewController: UIViewController {
        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        var delegate: ScannerCoordinator?
        
       
        override public func viewDidLoad() {
            super.viewDidLoad()

            
            
                     
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(updateOrientation),
                                                   name: Notification.Name("UIDeviceOrientationDidChangeNotification"),
                                                   object: nil)

            view.backgroundColor = UIColor.black
            captureSession = AVCaptureSession()

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput

            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }

            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                delegate?.didFail(reason: .badInput)
                return
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = delegate?.parent.codeTypes
            } else {
                delegate?.didFail(reason: .badOutput)
                return
            }
         
            
        }

        override public func viewWillLayoutSubviews() {
            previewLayer?.frame = view.layer.bounds
        }
        func createOverlay(frame: CGRect,
                           xOffset: CGFloat,
                           yOffset: CGFloat,
                           radius: CGFloat) -> UIView {
            // Step 1
            var firstRect = CGRect(x:0 , y: 0, width: view.frame.width / 1.3, height: 300 )
            firstRect.center = self.view.center
            var secondRect = CGRect(x:1 , y: 1, width: view.frame.width / 1.3 + 2, height: 302 )
            secondRect.center = self.view.center
            let overlayView = UIView(frame: frame)
            
            let borderView = UIView(frame: secondRect  )
            borderView.cornerRadius = radius
            borderView.center = self.view.center
            borderView.backgroundColor = UIColor.white
            overlayView.addSubview(borderView)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            let bottomMargin = CGFloat(50) //Space between button and bottom of the screen
            let buttonSize = CGSize(width: 100, height: 50)

            let button = UIButton(frame: CGRect(
                    x: 0, y: 20, width: buttonSize.width, height: buttonSize.height
                ))

            button.center = CGPoint(x: overlayView.bounds.size.width / 2,
                                    y: overlayView.bounds.size.height - buttonSize.height / 2 - bottomMargin)
            overlayView.addSubview(button)
            // Step 2 r
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: xOffset * 2, height: self.view.bounds.size.height), cornerRadius: 0)
            
            
            
            path.append(UIBezierPath(roundedRect: firstRect , cornerRadius: radius))
            
            path.usesEvenOddFillRule = true
            
            
            
            // Step 3
            
            
            
            let maskLayer = CAShapeLayer()
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.path = path.cgPath
            
            
            // For Swift 4.0
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            // For Swift 4.2
            maskLayer.fillRule = .evenOdd
            // Step 4
            overlayView.layer.mask = maskLayer
            overlayView.clipsToBounds = true
            
            return overlayView
        }
        @objc func updateOrientation() {
            guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                return
            }
            let previewConnection = captureSession.connections[1]
            previewConnection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) ?? .portrait
        }

        override public func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            updateOrientation()
            captureSession.startRunning()
            let overlay = createOverlay(frame: view.frame,
                                                  xOffset: view.frame.width / 2,
                                                  yOffset: view.frame.height / 2,
                                                  radius: 45)
           // view.layer.addSublayer(overlay)
            self.view.addSubview(overlay)
        }

        override public func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }

        override public func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }

            NotificationCenter.default.removeObserver(self)
        }

        override public var prefersStatusBarHidden: Bool {
            return true
        }

        override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .all
        }
    }
    #endif

    public let codeTypes: [AVMetadataObject.ObjectType] = [.qr]
    public var simulatedData = ""
    public var completion: (Result<String, ScanError>) -> Void

    public init(codeTypes: [AVMetadataObject.ObjectType], simulatedData: String = "", completion: @escaping (Result<String, ScanError>) -> Void) {
        
        self.simulatedData = simulatedData
        self.completion = completion
    }

    public func makeCoordinator() -> ScannerCoordinator {
        return ScannerCoordinator(parent: self)
    }

    public func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    public func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {

    }
}

struct CodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        CodeScannerView(codeTypes: [.qr]) { result in
            // do nothing
        }
    }
}

