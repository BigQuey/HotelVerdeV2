//
//  PagoDetalleAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit
import FirebaseFirestore
class PagoDetalleAdminViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tfUsuario: UITextField!
    @IBOutlet weak var tfMonto: UITextField!
    @IBOutlet weak var tfFecha: UITextField!
    @IBOutlet weak var tfMetodo: UITextField!
    // Variable auxiliar para la fecha
    private var fechaSeleccionada: Date?
    private let datePicker = UIDatePicker()
    // Variables para el selector de Método
    var listaTodosUsuarios: [String] = ["Juan Perez", "Maria Delgado", "Carlos Ruiz", "Ana Gomez", "Hotel Admin", "Pedro Castillo", "Luisa Lane"]
    private let pickerView = UIPickerView()
    private let opcionesPago = [
        "Efectivo", "Yape", "Plin", "Tarjeta Débito", "Tarjeta Crédito",
    ]
    let tableViewSugerencias = UITableView()
    var usuariosFiltrados: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarCalendario()
        configurarSelectorMetodo()
        configurarAutocomplete()
        cargarUsuariosDeFirebase()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 1. CONVERSIÓN DE COORDENADAS (IMPORTANTE)
        // Calculamos dónde está el campo de texto con respecto a TODA la pantalla,
        // no solo con respecto a su contenedor padre.
        guard let frameGlobal = tfUsuario.superview?.convert(tfUsuario.frame, to: self.view) else { return }

        tableViewSugerencias.frame = CGRect(
            x: frameGlobal.origin.x,
            y: frameGlobal.origin.y + frameGlobal.height,
            width: frameGlobal.width,
            height: 150
        )

        tableViewSugerencias.layer.zPosition = 1

        tableViewSugerencias.backgroundColor = .white
        
        tableViewSugerencias.layer.shadowColor = UIColor.black.cgColor
        tableViewSugerencias.layer.shadowOpacity = 0.3
        tableViewSugerencias.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableViewSugerencias.layer.shadowRadius = 3
    }
    func configurarAutocomplete() {
        tableViewSugerencias.delegate = self
        tableViewSugerencias.dataSource = self
        tableViewSugerencias.register(
            UITableViewCell.self, forCellReuseIdentifier: "celdaUsuario")
        tableViewSugerencias.isHidden = true
        tableViewSugerencias.layer.borderWidth = 1
        tableViewSugerencias.layer.borderColor = UIColor.lightGray.cgColor
        tableViewSugerencias.layer.cornerRadius = 5

        view.addSubview(tableViewSugerencias)

        tfUsuario.addTarget(
            self, action: #selector(filtrarUsuarios), for: .editingChanged)
    }
    @objc func filtrarUsuarios() {
        guard let texto = tfUsuario.text, !texto.isEmpty else {
                usuariosFiltrados.removeAll()
                tableViewSugerencias.isHidden = true
                return
            }
            
            usuariosFiltrados = listaTodosUsuarios.filter { usuario in
                return usuario.lowercased().contains(texto.lowercased())
            }
            
            // ---> AGREGA ESTA LÍNEA <---
            print("Texto: \(texto) | Encontrados: \(usuariosFiltrados.count) | Frame Tabla: \(tableViewSugerencias.frame)")
            
            tableViewSugerencias.isHidden = usuariosFiltrados.isEmpty
            tableViewSugerencias.reloadData()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return usuariosFiltrados.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaUsuario", for: indexPath)
            celda.textLabel?.text = usuariosFiltrados[indexPath.row]
            celda.backgroundColor = .white
            celda.textLabel?.textColor = .black
            return celda
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // 1. Poner el nombre seleccionado en el campo de texto
            tfUsuario.text = usuariosFiltrados[indexPath.row]
            
            // 2. Ocultar la tabla y limpiar filtro
            tableViewSugerencias.isHidden = true
            tfUsuario.resignFirstResponder() // Opcional: bajar teclado al seleccionar
            
            // Efecto visual de deselección
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    // MARK: - Configuración de Método (NUEVO)
    func configurarSelectorMetodo() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white

        // Asignamos el picker como el teclado del campo de texto
        tfMetodo.inputView = pickerView

        // Añadimos la barra con el botón "Listo"
        let toolbar = crearToolbar(selector: #selector(confirmarMetodo))
        tfMetodo.inputAccessoryView = toolbar
    }
    @objc func confirmarMetodo() {
        // Si el usuario da "Listo" sin mover la rueda, seleccionamos el primero por defecto
        if tfMetodo.text?.isEmpty ?? true {
            tfMetodo.text = opcionesPago[0]
        }
        view.endEditing(true)
    }
    func crearToolbar(selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let btnListo = UIBarButtonItem(
            title: "Listo", style: .done, target: self, action: selector)
        let espacio = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([espacio, btnListo], animated: true)
        return toolbar
    }
    func configurarCalendario() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame.size.height = 200

        tfFecha.inputView = datePicker

        // Barra de herramientas para el teclado
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
        tfFecha.inputAccessoryView = toolbar

        datePicker.addTarget(
            self, action: #selector(cambioFecha), for: .valueChanged)
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
        // 1. Validar campos (Añadimos validación de método)
        guard let nombre = tfUsuario.text, !nombre.isEmpty,
            let montoTexto = tfMonto.text, !montoTexto.isEmpty,
            let montoDouble = Double(montoTexto),
            let fecha = fechaSeleccionada,
            let metodo = tfMetodo.text, !metodo.isEmpty  // <--- Validamos método
        else {
            mostrarAlerta(
                mensaje: "Por favor complete todos los datos correctamente")
            return
        }

        // 2. Crear objeto (Usamos el método seleccionado)
        let nuevoPago = Pago(
            id: nil,
            nombreCliente: nombre,
            monto: montoDouble,
            fecha: fecha,
            metodo: metodo  // <--- Ya no es hardcodeado "Efectivo"
        )

        // 3. Guardar con DAO
        let dao = PagoDAO()
        dao.guardar(pago: nuevoPago) { exito in
            if exito {
                self.dismiss(animated: true)
            } else {
                self.mostrarAlerta(mensaje: "Error al guardar en la nube")
            }
        }
    }

    @IBAction func volverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    func mostrarAlerta(mensaje: String) {
        let alert = UIAlertController(
            title: "Atención", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - UIPickerView Delegate & DataSource Methods

    // Cuántas columnas tiene la rueda (Solo 1 lista de opciones)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Cuántas filas tiene la rueda
    func pickerView(
        _ pickerView: UIPickerView, numberOfRowsInComponent component: Int
    ) -> Int {
        return opcionesPago.count
    }

    // Qué texto mostrar en cada fila
    func pickerView(
        _ pickerView: UIPickerView, titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return opcionesPago[row]
    }

    // Qué pasa cuando seleccionas una fila
    func pickerView(
        _ pickerView: UIPickerView, didSelectRow row: Int,
        inComponent component: Int
    ) {
        tfMetodo.text = opcionesPago[row]
    }
    func cargarUsuariosDeFirebase() {
        let db = Firestore.firestore()
        db.collection("usuarios").getDocuments { snapshot, error in
            if let docs = snapshot?.documents {
                // Mapeamos los documentos para sacar solo los nombres
                self.listaTodosUsuarios = docs.map { $0["nombre"] as? String ?? "Desconocido" }
            }
        }
    }
}
