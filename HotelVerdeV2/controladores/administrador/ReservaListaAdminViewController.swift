//
//  ReservaListaAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit
import FirebaseFirestore

class ReservaListaAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tvReservas: UITableView!

    var listaReservas: [Reserva] = []
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        tvReservas.delegate = self
        tvReservas.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarDatos()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }

    func cargarDatos() {
        let dao = ReservaDAO()
        listener = dao.escucharReservas { [weak self] reservas in
            self?.listaReservas = reservas
            DispatchQueue.main.async {
                self?.tvReservas.reloadData()
            }
        }
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaReservas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaReserva", for: indexPath)
        let item = listaReservas[indexPath.row]
        
        let formateador = DateFormatter()
        formateador.dateStyle = .short
        let fechaTexto = formateador.string(from: item.fechaInicio)

        cell.textLabel?.text = "\(item.nombreCliente) \(item.apellidoCliente)"
        cell.detailTextLabel?.text = "Hotel: \(item.nombreHotel) - Entrada: \(fechaTexto)"

        return cell
    }

    // MARK: - NUEVO: Seleccionar celda para Editar
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Obtenemos la reserva seleccionada
        let reservaSeleccionada = listaReservas[indexPath.row]
        // Hacemos el viaje a la pantalla de Edición (Asegúrate que el segue se llame así en el Storyboard)
        performSegue(withIdentifier: "irEditarReserva", sender: reservaSeleccionada)
        
        // Deseleccionar visualmente
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navegación
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irEditarReserva" {
            // Pasamos el objeto a la pantalla de CRUD (Edición)
            if let destino = segue.destination as? ReservaCrudAdminViewController,
               let reserva = sender as? Reserva {
                destino.reservaRecibida = reserva
            }
        }
        // No hace falta lógica extra para "irNuevaReserva" porque va vacío
    }

    @IBAction func btnAgregarTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "irNuevaReserva", sender: self)
    }
    
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
