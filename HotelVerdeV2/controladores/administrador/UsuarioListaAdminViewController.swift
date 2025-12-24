//
//  UsuarioListaAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit
import FirebaseFirestore

class UsuarioListaAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tvUsuarios: UITableView!
    
    var listaUsuarios: [Usuario] = []
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvUsuarios.delegate = self
        tvUsuarios.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarUsuarios()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    func cargarUsuarios() {
        let dao = UsuarioDAO()
        listener = dao.escucharUsuarios { [weak self] usuarios in
            self?.listaUsuarios = usuarios
            DispatchQueue.main.async {
                self?.tvUsuarios.reloadData()
            }
        }
    }
    
    // MARK: - Tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaUsuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaUsuario", for: indexPath)
        let u = listaUsuarios[indexPath.row]
        
        cell.textLabel?.text = u.nombre
        cell.detailTextLabel?.text = u.email
        
        return cell
    }
    
    // MARK: - Navegación (Detalle y Nuevo)
    
    // 1. Ir a NUEVO (Botón Agregar)
    @IBAction func btnAgregarTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "irNuevoUsuario", sender: self)
    }
    
    // 2. Ir a DETALLE (Seleccionar celda)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuarioSeleccionado = listaUsuarios[indexPath.row]
        performSegue(withIdentifier: "verDetalleUsuario", sender: usuarioSeleccionado)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalleUsuario" {
            if let destino = segue.destination as? UsuarioCrudAdminViewController {
                destino.usuarioRecibido = sender as? Usuario
            }
        }
    }
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
