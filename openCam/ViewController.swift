//
//  ViewController.swift
//  openCam
//
//  Created by Natanael Alves Pereira on 10/10/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIApplicationDelegate {
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Abrir Câmera", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        view.addSubview(cameraButton)
        
        // Configurar restrições para centralizar o botão
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
    }
    
    @objc func openCamera() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
                DispatchQueue.main.async {
                    if accessGranted == true {
                        self.openImagePicker()
                    } else {
                        self.redirect()
                    }
                }
            })

       }
    
    deinit {
        // Lembre-se de remover o observador quando a view controller for liberada
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
                case .authorized:
                    openCamera()
                case .notDetermined:
                    print( "not")
                case .denied, .restricted:
                    print("permissoes negadas")
                default:
                    print( "default")
                }
    }
//    }
    
    func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("A câmera não está disponível neste dispositivo.")
        }
    }
    
    func navigationController(_ picker: UIImagePickerController ,_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is UIImagePickerController {
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

            if cameraAuthorizationStatus == .denied {
                navigationController.dismiss(animated: true, completion: {
                    self.redirect()
                })
            }
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        if cameraAuthorizationStatus == .denied {
            redirect()
        }
        
    }
        
//    override func viewWillAppear(_ animated: Bool) {
//        let status = cameraAuthorizationStatus()
//        if status {
//
//        } else {
//            redirect()
//        }
//    }
    
    
    
    func redirect() {
        let vc = Permissoes()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

