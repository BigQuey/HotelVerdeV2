//
//  GeneraUsuarioAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit

class GeneraUsuarioAdminViewController: UIViewController {

    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfClave: UITextField!

    @IBAction func btnAgregarTapped(_ sender: UIButton) {
        guard let nombre = tfNombre.text, !nombre.isEmpty,
            let email = tfEmail.text, !email.isEmpty,
            let clave = tfClave.text, !clave.isEmpty
        else {
            return
        }

        let nuevoUsuario = Usuario(
            id: nil, nombre: nombre, email: email, clave: clave, rol: "usuario")

        let dao = UsuarioDAO()
        dao.guardar(usuario: nuevoUsuario) { exito in
            if exito {
                self.dismiss(animated: true)
            }
        }
    }

    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
