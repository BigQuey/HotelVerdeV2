//
//  GeneraReservaAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 24/12/25.
//

import UIKit

class GeneraReservaAdminViewController: UIViewController {

    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfDNI: UITextField!
    @IBOutlet weak var tfHotel: UITextField!
    @IBOutlet weak var tfFechaInicio: UITextField!
    @IBOutlet weak var tfFechaFin: UITextField!

    private var fechaInicioSel: Date?
    private var fechaFinSel: Date?
    private let datePickerInicio = UIDatePicker()
    private let datePickerFin = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarFechas()
    }

    @IBAction func btnGuardarTapped(_ sender: UIButton) {
        
        guard let nombre = tfNombre.text, !nombre.isEmpty,
              let apellido = tfApellido.text, !apellido.isEmpty,
              let dni = tfDNI.text, !dni.isEmpty,
              let hotel = tfHotel.text, !hotel.isEmpty,
              let fInicio = fechaInicioSel,
              let fFin = fechaFinSel
        else {
            mostrarAlerta(titulo: "Faltan Datos", mensaje: "Por favor complete todos los campos")
            return
        }

        let nuevaReserva = Reserva(
            id: "",
            idHotel: "",
            nombreHotel: hotel,
            nombreCliente: nombre,
            apellidoCliente: apellido,
            dniCliente: dni,
            fechaInicio: fInicio,
            fechaFin: fFin,
            fechaCreacion: Date()
        )

        let dao = ReservaDAO()
        dao.guardar(reserva: nuevaReserva) { exito in
            if exito {
                self.mostrarAlerta(titulo: "Éxito", mensaje: "Reserva creada correctamente") {
                    self.dismiss(animated: true)
                }
            } else {
                self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo guardar la reserva")
            }
        }
    }

    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func configurarFechas() {
        crearDatePicker(picker: datePickerInicio, textField: tfFechaInicio, selector: #selector(cambioFechaInicio))
        crearDatePicker(picker: datePickerFin, textField: tfFechaFin, selector: #selector(cambioFechaFin))
    }

    func crearDatePicker(picker: UIDatePicker, textField: UITextField, selector: Selector) {
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.frame.size.height = 200
        textField.inputView = picker

        let toolbar = UIToolbar(); toolbar.sizeToFit()
        let btnListo = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(cerrarTeclado))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), btnListo], animated: true)
        textField.inputAccessoryView = toolbar

        picker.addTarget(self, action: selector, for: .valueChanged)
    }

    @objc func cerrarTeclado() { view.endEditing(true) }

    @objc func cambioFechaInicio() {
        fechaInicioSel = datePickerInicio.date
        let f = DateFormatter(); f.dateStyle = .medium
        tfFechaInicio.text = f.string(from: datePickerInicio.date)
    }

    @objc func cambioFechaFin() {
        fechaFinSel = datePickerFin.date
        let f = DateFormatter(); f.dateStyle = .medium
        tfFechaFin.text = f.string(from: datePickerFin.date)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, completion: (() -> Void)? = nil) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alerta, animated: true)
    }
}
