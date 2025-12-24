//
//  RegisterViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nombreTextField: UITextField!

    @IBOutlet weak var apellidoTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func registrarUsuarioTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let nombre = nombreTextField.text, !nombre.isEmpty,
            let apellido = apellidoTextField.text, !apellido.isEmpty
        else {
            print("Faltan datos")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in

            if let error = error {
                print("Error creando usuario: \(error.localizedDescription)")
                return
            }

            guard let uid = result?.user.uid else { return }

            let datosUsuario: [String: Any] = [
                "uid": uid,
                "nombre": nombre,
                "apellido": apellido,
                "correo": email,
                "rol": "usuario",
            ]

            self.db.collection("usuarios").document(uid).setData(datosUsuario) {
                error in
                if let error = error {
                    print("Error guardando datos en Firestore: \(error)")
                } else {
                    print("¡Usuario registrado y guardado!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

    }

}
