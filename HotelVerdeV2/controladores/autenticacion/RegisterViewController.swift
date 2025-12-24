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
            print("Faltan datos")  // Aquí pon una alerta
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in

            if let error = error {
                print("Error creando usuario: \(error.localizedDescription)")
                return
            }

            // 3. Si se creó con éxito, guardar datos extra en Firestore
            guard let uid = result?.user.uid else { return }

            // Creamos el diccionario de datos (coincidiendo con tu struct Usuario)
            let datosUsuario: [String: Any] = [
                "uid": uid,
                "nombre": nombre,
                "apellido": apellido,
                "correo": email,
                "rol": "usuario",  // Por defecto "usuario". Cambia a "admin" si es necesario.
            ]

            self.db.collection("usuarios").document(uid).setData(datosUsuario) {
                error in
                if let error = error {
                    print("Error guardando datos en Firestore: \(error)")
                } else {
                    print("¡Usuario registrado y guardado!")
                    // Aquí cierras la vista para volver al login o vas al Home
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

    }

}
