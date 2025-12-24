//
//  PagoDetalleAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit

class PagoDetalleAdminViewController: UIViewController {

        @IBOutlet weak var tfUsuario: UITextField!
        @IBOutlet weak var tfMonto: UITextField!
        @IBOutlet weak var tfFecha: UITextField!
        
        // Variable auxiliar para la fecha
        private var fechaSeleccionada: Date?
        private let datePicker = UIDatePicker()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            configurarCalendario()
        }
        
        func configurarCalendario() {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.frame.size.height = 200
            
            tfFecha.inputView = datePicker
            
            // Barra de herramientas para el teclado
            let toolbar = UIToolbar(); toolbar.sizeToFit()
            let btnListo = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(cerrarTeclado))
            toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), btnListo], animated: true)
            tfFecha.inputAccessoryView = toolbar
            
            datePicker.addTarget(self, action: #selector(cambioFecha), for: .valueChanged)
        }
        
        @objc func cerrarTeclado() { view.endEditing(true) }
        
        @objc func cambioFecha() {
            fechaSeleccionada = datePicker.date
            let df = DateFormatter()
            df.dateStyle = .medium
            tfFecha.text = df.string(from: datePicker.date)
        }

        // MARK: - Guardar
        @IBAction func guardarTapped(_ sender: UIButton) {
            
            // Validar campos
            guard let nombre = tfUsuario.text, !nombre.isEmpty,
                  let montoTexto = tfMonto.text, !montoTexto.isEmpty,
                  let montoDouble = Double(montoTexto), // Convertir texto a número
                  let fecha = fechaSeleccionada
            else {
                print("Faltan datos o el monto no es un número")
                return
            }
            
            // Crear objeto
            let nuevoPago = Pago(
                id: nil,
                nombreCliente: nombre,
                monto: montoDouble,
                fecha: fecha,
                metodo: "Efectivo"
            )
            
            // Guardar con DAO
            let dao = PagoDAO()
            dao.guardar(pago: nuevoPago) { exito in
                if exito {
                    self.dismiss(animated: true)
                } else {
                    print("Error al guardar pago")
                }
            }
        }
        
        @IBAction func volverTapped(_ sender: UIButton) {
            dismiss(animated: true)
        }
}
