//
//  HotelCrudAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit
import FirebaseFirestore
class HotelCrudAdminViewController: UIViewController {

    @IBOutlet weak var tfCodigo: UITextField!

    @IBOutlet weak var tfNombre: UITextField!

    @IBOutlet weak var tfCiudad: UITextField!

    @IBOutlet weak var tfDescripcion: UITextField!

    @IBOutlet weak var tfServicio: UITextField!

    var hotelRecibido: Hotel?
    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarDatos()

    }
    func mostrarDatos() {
        if let hotel = hotelRecibido {
            tfCodigo.text = hotel.codigo
            tfNombre.text = hotel.nombre
            tfCiudad.text = hotel.ciudad
            tfDescripcion.text = hotel.descripcion
            tfServicio.text = hotel.servicio
        }
    }

    @IBAction func modificarTapped(_ sender: UIButton) {
        guard let id = hotelRecibido?.id else { return }

        // Recolectar nuevos datos
        let datosActualizados: [String: Any] = [
            "codigo": tfCodigo.text ?? "",
            "nombre": tfNombre.text ?? "",
            "ciudad": tfCiudad.text ?? "",
            "descripcion": tfDescripcion.text ?? "",
            "servicio": tfServicio.text ?? "",
        ]

        db.collection("hoteles").document(id).updateData(datosActualizados) {
            error in
            if let error = error {
                print("Error al actualizar: \(error)")
            } else {
                print("Actualizado correctamente")
                self.dismiss(animated: true)
            }
        }
    }

    @IBAction func eliminarTapped(_ sender: UIButton) {
        guard let id = hotelRecibido?.id else { return }

        // Alerta de confirmación
        let alerta = UIAlertController(
            title: "Eliminar", message: "¿Estás seguro?", preferredStyle: .alert
        )
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(
            UIAlertAction(
                title: "Eliminar", style: .destructive,
                handler: { _ in

                    self.db.collection("hoteles").document(id).delete { error in
                        if let error = error {
                            print("Error borrando: \(error)")
                        } else {
                            self.dismiss(animated: true)
                        }
                    }
                }))
        present(alerta, animated: true)
    }

    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
