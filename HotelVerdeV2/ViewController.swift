//
//  ViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButton: UIButton!

    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        print("boton presionado")
        // 1. Validar que los campos no estén vacíos
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            mostrarAlerta(mensaje: "Por favor ingrese correo y contraseña")
            return
        }

        // 2. Intentar loguearse con Firebase Auth
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] authResult, error in

            if let error = error {
                // Error en credenciales (contraseña mal, usuario no existe)
                self?.mostrarAlerta(
                    mensaje: "Error: \(error.localizedDescription)")
                return
            }

            // 3. Login exitoso -> Obtener el ROL del usuario desde Firestore
            guard let userID = authResult?.user.uid else { return }
            self?.verificarRolYNavigar(uid: userID)
        }

    }
    func verificarRolYNavigar(uid: String) {

        db.collection("usuarios").document(uid).getDocument {
            (document, error) in

            if let document = document, document.exists {

                let data = document.data()
                let rol = data?["rol"] as? String ?? "usuario"
                if rol == "admin" {
                    self.irAPantallaAdmin()
                } else {
                    self.irAPantallaUsuario()
                }

            } else {
                self.mostrarAlerta(
                    mensaje: "Usuario no encontrado en la base de datos.")
            }
        }
    }

    func irAPantallaAdmin() {
        // Asegúrate de ponerle el Storyboard ID "HomeAdminViewController" a tu vista en el Storyboard
        if let adminVC = self.storyboard?.instantiateViewController(
            withIdentifier: "HomeAdminViewController")
        {
            adminVC.modalPresentationStyle = .fullScreen  // Para que no se pueda volver atrás deslizando
            self.present(adminVC, animated: true, completion: nil)
        }
    }

    func irAPantallaUsuario() {
        // Asegúrate de ponerle el Storyboard ID "HomeUsuarioViewController" (o tu TabBar)
        // NOTA: Si ya creaste el TabBar, aquí deberías llamar al ID del TabBarController
        if let userVC = self.storyboard?.instantiateViewController(
            withIdentifier: "HomeUsuarioViewController")
        {
            userVC.modalPresentationStyle = .fullScreen
            self.present(userVC, animated: true, completion: nil)
        }
    }

    func mostrarAlerta(mensaje: String) {
        let alert = UIAlertController(
            title: "Atención", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func irARegistroTapped(_ sender: UIButton) {
        if let registerVC = self.storyboard?.instantiateViewController(
            withIdentifier: "RegisterViewController") as? RegisterViewController
        {

            // Opcional: Define cómo quieres que aparezca
            // .automatic o .pageSheet permite al usuario deslizar hacia abajo para cancelar
            // .fullScreen obliga al usuario a usar un botón "Atrás" que tú programes
            registerVC.modalPresentationStyle = .automatic

            self.present(registerVC, animated: true, completion: nil)
        }
    }

}
