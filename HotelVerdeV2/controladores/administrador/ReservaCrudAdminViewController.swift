//
//  ReservaCrudAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit

class ReservaCrudAdminViewController: UIViewController {
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfDNI: UITextField!
    @IBOutlet weak var tfHotel: UITextField!
    @IBOutlet weak var tfFechaInicio: UITextField!
    @IBOutlet weak var tfFechaFin: UITextField!

    var reservaRecibida: Reserva?

    private var fechaInicioSel: Date?
    private var fechaFinSel: Date?
    private let datePickerInicio = UIDatePicker()
    private let datePickerFin = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarFechas()
        cargarDatosEnPantalla()
    }

    func cargarDatosEnPantalla() {
        if let reserva = reservaRecibida {
            tfNombre.text = reserva.nombreCliente
            tfApellido.text = reserva.apellidoCliente
            tfDNI.text = reserva.dniCliente
            tfHotel.text = reserva.nombreHotel

            fechaInicioSel = reserva.fechaInicio
            fechaFinSel = reserva.fechaFin

            let formateador = DateFormatter()
            formateador.dateStyle = .medium
            tfFechaInicio.text = formateador.string(from: reserva.fechaInicio)
            tfFechaFin.text = formateador.string(from: reserva.fechaFin)
        }
    }

    @IBAction func btnEditarTapped(_ sender: UIButton) {
        guard let id = reservaRecibida?.id,
            let nombre = tfNombre.text, !nombre.isEmpty,
            let apellido = tfApellido.text, !apellido.isEmpty,
            let dni = tfDNI.text, !dni.isEmpty,
            let hotel = tfHotel.text, !hotel.isEmpty,
            let fInicio = fechaInicioSel,
            let fFin = fechaFinSel
        else {
            return
        }

        let reservaActualizada = Reserva(
            id: id,
            idHotel: "",
            nombreHotel: hotel,
            nombreCliente: nombre,
            apellidoCliente: apellido,
            dniCliente: dni,

            fechaInicio: fInicio,
            fechaFin: fFin,
            fechaCreacion: reservaRecibida?.fechaCreacion ?? Date()
        )

        let dao = ReservaDAO()
        dao.actualizar(reserva: reservaActualizada) { exito in
            if exito {
                self.mostrarAlerta(
                    titulo: "Éxito",
                    mensaje: "Reserva actualizada correctamente"
                ) {
                    self.dismiss(animated: true)
                }
            } else {
                self.mostrarAlerta(
                    titulo: "Error", mensaje: "No se pudo actualizar")
            }
        }
    }

    @IBAction func btnEliminarTapped(_ sender: UIButton) {
        guard let id = reservaRecibida?.id else { return }

        let alerta = UIAlertController(
            title: "Eliminar Reserva",
            message: "¿Está seguro? Esta acción no se puede deshacer.",
            preferredStyle: .alert)

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(
            UIAlertAction(title: "Eliminar", style: .destructive) { _ in

                let dao = ReservaDAO()
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

    func configurarFechas() {
        crearDatePicker(
            picker: datePickerInicio, textField: tfFechaInicio,
            selector: #selector(cambioFechaInicio))
        crearDatePicker(
            picker: datePickerFin, textField: tfFechaFin,
            selector: #selector(cambioFechaFin))
    }

    func crearDatePicker(
        picker: UIDatePicker, textField: UITextField, selector: Selector
    ) {
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.frame.size.height = 200
        textField.inputView = picker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let btnListo = UIBarButtonItem(
            title: "Listo", style: .done, target: self,
            action: #selector(cerrarTeclado))
        toolbar.setItems(
            [
                UIBarButtonItem(
                    barButtonSystemItem: .flexibleSpace, target: nil,
                    action: nil), btnListo,
            ], animated: true)
        textField.inputAccessoryView = toolbar

        picker.addTarget(self, action: selector, for: .valueChanged)
    }

    @objc func cerrarTeclado() { view.endEditing(true) }

    @objc func cambioFechaInicio() {
        fechaInicioSel = datePickerInicio.date
        let f = DateFormatter()
        f.dateStyle = .medium
        tfFechaInicio.text = f.string(from: datePickerInicio.date)
    }

    @objc func cambioFechaFin() {
        fechaFinSel = datePickerFin.date
        let f = DateFormatter()
        f.dateStyle = .medium
        tfFechaFin.text = f.string(from: datePickerFin.date)
    }

    func mostrarAlerta(
        titulo: String, mensaje: String, completion: (() -> Void)? = nil
    ) {
        let alerta = UIAlertController(
            title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alerta, animated: true)
    }
}
