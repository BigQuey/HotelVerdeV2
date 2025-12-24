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
    var listener: ListenerRegistration?  // Para poder apagar la escucha al salir

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
        // Dejamos de escuchar cambios cuando salimos de la pantalla para ahorrar datos
        listener?.remove()
    }

    func cargarDatos() {
        let dao = ReservaDAO()
        // Guardamos la referencia del listener
        listener = dao.escucharReservas { [weak self] reservas in
            self?.listaReservas = reservas
            DispatchQueue.main.async {
                self?.tvReservas.reloadData()
            }
        }
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return listaReservas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        // Asegúrate de poner el ID "celdaReserva" en el Storyboard
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "celdaReserva", for: indexPath)

        let item = listaReservas[indexPath.row]

        // Formatear fecha para que se vea bonita
        let formateador = DateFormatter()
        formateador.dateStyle = .short
        let fechaTexto = formateador.string(from: item.fechaInicio)

        cell.textLabel?.text = "\(item.nombreCliente) \(item.apellidoCliente)"
        cell.detailTextLabel?.text =
            "Hotel: \(item.nombreHotel) - Entrada: \(fechaTexto)"

        return cell
    }

    // MARK: - Navegación
    @IBAction func btnAgregarTapped(_ sender: UIButton) {
        // Conecta este Segue en el Storyboard hacia la vista de Nueva Reserva
        performSegue(withIdentifier: "irNuevaReserva", sender: self)
    }
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
