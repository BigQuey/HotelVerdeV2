

import UIKit
import FirebaseFirestore
class GeneraReservaUsuarioViewController: UIViewController {
    
        @IBOutlet weak var imgHotel: UIImageView!
        @IBOutlet weak var lblNombreHotel: UILabel!
        
        @IBOutlet weak var tfNombre: UITextField!
        @IBOutlet weak var tfDNI: UITextField!
        @IBOutlet weak var tfFechaInicio: UITextField!
        @IBOutlet weak var tfFechaFin: UITextField!
        
    
        var hotelRecibido: Hotel?
        
        
        private var fechaInicioSel: Date?
        private var fechaFinSel: Date?
        private let pickerInicio = UIDatePicker()
        private let pickerFin = UIDatePicker()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Mostrar información del hotel recibido
            if let hotel = hotelRecibido {
                lblNombreHotel.text = "Reservando en: \(hotel.nombre)"
               
            }
            
            configurarFechas()
        }
        
 
        @IBAction func guardarTapped(_ sender: UIButton) {
            
            // Validar que el hotel exista
            guard let hotel = hotelRecibido, let idHotel = hotel.id else {
                print("Error: No hay hotel seleccionado")
                return
            }
            
            // Validar campos del usuario
            guard let nombre = tfNombre.text, !nombre.isEmpty,
                  let dni = tfDNI.text, !dni.isEmpty,
                  let fInicio = fechaInicioSel,
                  let fFin = fechaFinSel else {
                mostrarAlerta(mensaje: "Complete todos los campos")
                return
            }
            
            //  Crear el objeto Reserva
            // NOTA: Usamos el ID y Nombre del hotel recibido automáticamente
            let nuevaReserva = Reserva(
                id: nil,
                idHotel: idHotel,           // <--- Vinculamos al ID del hotel
                nombreHotel: hotel.nombre,  // <--- Guardamos el nombre
                nombreCliente: nombre,
                apellidoCliente: "",
                dniCliente: dni,
                fechaInicio: fInicio,
                fechaFin: fFin,
                fechaCreacion: Date()
            )
            
            // Guardar usando el DAO
            let dao = ReservaDAO()
            dao.guardar(reserva: nuevaReserva) { exito in
                if exito {
                    self.mostrarAlerta(mensaje: "¡Reserva Exitosa!") {
                        self.dismiss(animated: true)
                    }
                } else {
                    self.mostrarAlerta(mensaje: "Error al guardar")
                }
            }
        }
        
        @IBAction func volverTapped(_ sender: UIButton) {
            dismiss(animated: true)
        }
        
        
        func configurarFechas() {
            configurarPicker(picker: pickerInicio, textField: tfFechaInicio, action: #selector(cambioInicio))
            configurarPicker(picker: pickerFin, textField: tfFechaFin, action: #selector(cambioFin))
        }
        
        func configurarPicker(picker: UIDatePicker, textField: UITextField, action: Selector) {
            picker.datePickerMode = .date
            picker.preferredDatePickerStyle = .wheels
            picker.frame.size.height = 200
            textField.inputView = picker
            
            let toolbar = UIToolbar(); toolbar.sizeToFit()
            let btn = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(cerrarTeclado))
            toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), btn], animated: true)
            textField.inputAccessoryView = toolbar
            
            picker.addTarget(self, action: action, for: .valueChanged)
        }
        
        @objc func cerrarTeclado() { view.endEditing(true) }
        
        @objc func cambioInicio() {
            fechaInicioSel = pickerInicio.date
            let f = DateFormatter(); f.dateStyle = .medium
            tfFechaInicio.text = f.string(from: pickerInicio.date)
        }
        
        @objc func cambioFin() {
            fechaFinSel = pickerFin.date
            let f = DateFormatter(); f.dateStyle = .medium
            tfFechaFin.text = f.string(from: pickerFin.date)
        }
        
        func mostrarAlerta(mensaje: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: "Hotel Verde", message: mensaje, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
            present(alert, animated: true)
        }


}
