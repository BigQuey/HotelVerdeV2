//
//  GenerarHotelAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import FirebaseFirestore
import UIKit

class GenerarHotelAdminViewController: UIViewController {

    @IBOutlet weak var tfCodigo: UITextField!

    @IBOutlet weak var tfNombre: UITextField!

    @IBOutlet weak var tfCiudad: UITextField!

    @IBOutlet weak var tfDescripcion: UITextField!

    @IBOutlet weak var tfServicio: UITextField!

    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func guardarTapped(_ sender: UIButton) {

        // 1. Validar que haya datos
        guard let codigo = tfCodigo.text, !codigo.isEmpty,
            let nombre = tfNombre.text, !nombre.isEmpty,
            let ciudad = tfCiudad.text, !ciudad.isEmpty,
            let descripcion = tfDescripcion.text, !descripcion.isEmpty,
            let servicio = tfServicio.text, !servicio.isEmpty
        else {
            print("Faltan campos")
            return
        }

        // 2. Crear el diccionario de datos
        // NOTA: Firestore genera el ID automáticamente, no necesitamos enviarlo aquí
        let datosHotel: [String: Any] = [
            "codigo": codigo,
            "nombre": nombre,
            "ciudad": ciudad,
            "descripcion": descripcion,
            "servicio": servicio,
            "fechaCreacion": Date(),  // Útil para ordenar
        ]

        // 3. Guardar en Firestore
        db.collection("hoteles").addDocument(data: datosHotel) { error in
            if let error = error {
                print("Error al guardar: \(error.localizedDescription)")
            } else {
                print("Hotel guardado exitosamente")
                self.dismiss(animated: true, completion: nil)  // Cierra la ventana
            }
        }

    }
    
    
    @IBAction func btnVolveer(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
