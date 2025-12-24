//
//  HotelesListaUsuarioViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import FirebaseFirestore
import UIKit

class HotelesListaUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tvHoteles: UITableView! // Asegúrate de conectarlo en el Storyboard
    
    // MARK: - Variables
    var listaHoteles: [Hotel] = []
    
    // Usamos tu DAO Híbrido (CoreData + Firebase)
    let dao = HotelDAO()
    
    // MARK: - Ciclo de Vida
    override func viewDidLoad() {
        super.viewDidLoad()
        tvHoteles.delegate = self
        tvHoteles.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarHoteles()
    }
    
    // MARK: - Carga de Datos
    func cargarHoteles() {
        // CORRECCIÓN: Usamos 'sincronizarHoteles' que es la función que SÍ tienes en tu DAO
        dao.sincronizarHoteles { [weak self] hotelesRecibidos in
            self?.listaHoteles = hotelesRecibidos
            
            DispatchQueue.main.async {
                self?.tvHoteles.reloadData()
            }
        }
    }
    
    // MARK: - Tabla DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaHoteles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Asegúrate que la celda en el Storyboard tenga el ID "celdaHotelUsuario"
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaHotelUsuario", for: indexPath)
        
        let hotel = listaHoteles[indexPath.row]
        
        // Configuración visual
        cell.textLabel?.text = hotel.nombre
        // Usamos 'ciudad' y 'servicio' porque tu struct Hotel NO tiene precio
        cell.detailTextLabel?.text = "\(hotel.ciudad) - \(hotel.servicio)"
        
        return cell
    }
    
    // MARK: - Selección (Ir a Reservar)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hotelSeleccionado = listaHoteles[indexPath.row]
        
        // Al tocar un hotel, vamos a la pantalla de crear reserva enviando el hotel
        performSegue(withIdentifier: "irAGenerarReserva", sender: hotelSeleccionado)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navegación
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irAGenerarReserva" {
            // Asegúrate que el destino sea GeneraReservaUsuarioViewController
            if let destino = segue.destination as? GeneraReservaUsuarioViewController {
                // Pasamos el hotel para que la reserva sepa de quién es
                // (sender es el objeto Hotel que enviamos en el didSelectRowAt)
                destino.hotelRecibido = sender as? Hotel
            }
        }
    }
    
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
