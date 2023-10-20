//
//  Permissoes.swift
//  openCam
//
//  Created by Natanael Alves Pereira on 10/10/2023.
//

import UIKit
import AVFoundation

class Permissoes: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Abrir Permissoes", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(cameraButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        // Configurar restrições para centralizar o botão
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        cameraButton.addTarget(self, action: #selector(abrirPermissoes), for: .touchUpInside)
    }
    
    @objc func appDidBecomeActive() {
        cameraAuthorizationStatus()
        }

        
        deinit {
            // Lembre-se de remover o observador quando a view controller for liberada
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
 
    func  cameraAuthorizationStatus() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
                case .authorized:
                    openCamera()
                case .notDetermined:
                    // A permissão ainda não foi solicitada; solicite-a aqui usando UIImagePickerController
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                case .denied, .restricted:
                    print("permissoes negadas")
                default:
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                    print("A câmera não está disponível neste dispositivo.")
                }
    }
    
    @objc private func abrirPermissoes() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
}
