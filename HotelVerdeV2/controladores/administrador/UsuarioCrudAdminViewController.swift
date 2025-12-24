//
//  UsuarioCrudAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit

class UsuarioCrudAdminViewController: UIViewController {

    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfClave: UITextField!

    var usuarioRecibido: Usuario?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let u = usuarioRecibido {
            tfNombre.text = u.nombre
            tfEmail.text = u.email
            tfClave.text = u.clave
        }
    }

    @IBAction func btnGrabarTapped(_ sender: UIButton) {
        guard let id = usuarioRecibido?.id,
            let nombre = tfNombre.text, !nombre.isEmpty,
            let email = tfEmail.text, !email.isEmpty,
            let clave = tfClave.text, !clave.isEmpty
        else { return }

        let usuarioEditado = Usuario(
            id: id, nombre: nombre, email: email, clave: clave,
            rol: usuarioRecibido?.rol ?? "usuario")

        let dao = UsuarioDAO()
        dao.editar(usuario: usuarioEditado) { exito in
            if exito {
                self.dismiss(animated: true)
            }
        }
    }

    @IBAction func btnEliminarTapped(_ sender: UIButton) {
        guard let id = usuarioRecibido?.id else { return }

        let alerta = UIAlertController(
            title: "Eliminar", message: "¿Seguro?", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(
            UIAlertAction(title: "Eliminar", style: .destructive) { _ in
                let dao = UsuarioDAO()
                dao.eliminar(id: id) { exito in
                    if exito {
                        self.dismiss(animated: true)
                    }
                }
            })
        present(alerta, animated: true)
    }

    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
