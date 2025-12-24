//
//  ComentarioGeneraUsuarioViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit

class ComentarioGeneraUsuarioViewController: UIViewController {

    // MARK: - Outlets
    // Conecta este outlet al cuadro de texto grande (UITextView)
    @IBOutlet weak var txtComentario: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarEstiloTextView()
    }
    
    // Hacemos que el TextView parezca una cajita con borde (por defecto viene plano)
    func configurarEstiloTextView() {
        txtComentario.layer.borderColor = UIColor.lightGray.cgColor
        txtComentario.layer.borderWidth = 1.0
        txtComentario.layer.cornerRadius = 5.0
    }

    // MARK: - Botón Guardar
    @IBAction func btnGuardarTapped(_ sender: UIButton) {
        
        // 1. Validar que no esté vacío
        guard let texto = txtComentario.text, !texto.isEmpty else {
            mostrarAlerta(mensaje: "El comentario no puede estar vacío.")
            return
        }
        
        // 2. Crear objeto
        let nuevoComentario = Comentario(
            id: "", // Se genera solo
            contenido: texto,
            fecha: Date()
        )
        
        // 3. Guardar
        let dao = ComentarioDAO()
        dao.guardar(comentario: nuevoComentario) { exito in
            if exito {
                self.dismiss(animated: true)
            } else {
                self.mostrarAlerta(mensaje: "Hubo un error al guardar.")
            }
        }
    }
    
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Atención", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
}
