//
//  ComentarioListaUsuarioViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit
import FirebaseFirestore

class ComentarioListaUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    // CONECTA ESTO A LA TABLA EN EL STORYBOARD
    @IBOutlet weak var tvComentarios: UITableView!

    var listaComentarios: [Comentario] = []
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración básica de tabla
        tvComentarios.delegate = self
        tvComentarios.dataSource = self
        
        // Cargar datos
        cargarDatos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Dejar de escuchar cambios al salir para ahorrar batería/datos
        listener?.remove()
    }
    
    func cargarDatos() {
        let dao = ComentarioDAO()
        listener = dao.escucharComentarios { [weak self] comentarios in
            self?.listaComentarios = comentarios
            DispatchQueue.main.async {
                self?.tvComentarios.reloadData()
            }
        }
    }

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaComentarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Asegúrate de que la celda en el Storyboard tenga el Identifier "celdaComentario"
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaComentario", for: indexPath)
        
        let item = listaComentarios[indexPath.row]
        
        // Formatear la fecha
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        let fechaTexto = df.string(from: item.fecha)
        
        // Configurar textos
        cell.textLabel?.text = item.contenido
        cell.textLabel?.numberOfLines = 0 // Permitir que el texto sea multilínea
        cell.detailTextLabel?.text = fechaTexto
        
        return cell
    }
    
    // MARK: - Navegación
    @IBAction func btnAgregarTapped(_ sender: UIButton) {
        // Asegúrate de que el Segue desde el botón "Agregar" hacia la siguiente pantalla
        // tenga el identificador "irNuevoComentario"
        performSegue(withIdentifier: "irNuevoComentario", sender: self)
    }

    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
