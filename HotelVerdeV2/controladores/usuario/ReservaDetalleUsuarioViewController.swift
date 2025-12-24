
import UIKit

class ReservaDetalleUsuarioViewController: UIViewController {

    @IBOutlet weak var lblNombreHotel: UILabel! // O TextField deshabilitado
    @IBOutlet weak var tfFechaInicio: UITextField!
    @IBOutlet weak var tfFechaFin: UITextField!
    @IBOutlet weak var lblCliente: UILabel!
    
    // Variable que recibe la reserva
    var reservaRecibida: Reserva?
    
    // Calendarios
    private var fechaInicioSel: Date?
    private var fechaFinSel: Date?
    private let pickerInicio = UIDatePicker()
    private let pickerFin = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarFechas()
        cargarDatos()
    }
    
    func cargarDatos() {
        if let r = reservaRecibida {
            lblNombreHotel.text = r.nombreHotel
            lblCliente.text = "Reservado por: \(r.nombreCliente)"
            
            // Cargar fechas actuales
            fechaInicioSel = r.fechaInicio
            fechaFinSel = r.fechaFin
            
            let df = DateFormatter()
            df.dateStyle = .medium
            tfFechaInicio.text = df.string(from: r.fechaInicio)
            tfFechaFin.text = df.string(from: r.fechaFin)
        }
    }


    @IBAction func guardarCambiosTapped(_ sender: UIButton) {
        guard let r = reservaRecibida,
              let id = r.id,
              let fInicio = fechaInicioSel,
              let fFin = fechaFinSel else { return }
        
        // Creamos una copia de la reserva con las NUEVAS fechas
        let reservaActualizada = Reserva(
            id: id,
            idHotel: r.idHotel,
            nombreHotel: r.nombreHotel,
            nombreCliente: r.nombreCliente,
            apellidoCliente: r.apellidoCliente,
            dniCliente: r.dniCliente,
            fechaInicio: fInicio, // <--- Lo nuevo
            fechaFin: fFin,       // <--- Lo nuevo
            fechaCreacion: r.fechaCreacion
        )
        
        let dao = ReservaDAO()
        // Usamos el método 'actualizar' que ya creamos en el DAO
        dao.actualizar(reserva: reservaActualizada) { exito in
            if exito {
                self.mostrarAlerta(titulo: "Actualizado", mensaje: "Tus fechas han sido modificadas.") {
                    self.dismiss(animated: true)
                }
            } else {
                self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo actualizar.")
            }
        }
    }
    
    
    @IBAction func cancelarReservaTapped(_ sender: UIButton) {
        guard let id = reservaRecibida?.id else { return }
        
        let alerta = UIAlertController(title: "Cancelar Reserva", message: "¿Seguro que deseas cancelar?", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "No", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Sí, Cancelar", style: .destructive) { _ in
            
            let dao = ReservaDAO()
            dao.eliminar(id: id) { exito in
                if exito {
                    self.dismiss(animated: true)
                }
            }
        })
        present(alerta, animated: true)
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
        fechaInicioSel = pickerInicio.date; let f = DateFormatter(); f.dateStyle = .medium
        tfFechaInicio.text = f.string(from: pickerInicio.date)
    }
    
    @objc func cambioFin() {
        fechaFinSel = pickerFin.date; let f = DateFormatter(); f.dateStyle = .medium
        tfFechaFin.text = f.string(from: pickerFin.date)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
}
