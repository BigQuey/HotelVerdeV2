//
//  HotelListaViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import FirebaseFirestore
import UIKit

class HotelListaAdminViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource
{

    @IBOutlet weak var tvHotel: UITableView!

    var listaHoteles = [Hotel]()
    var db = Firestore.firestore()
    var hotelSeleccionado: Hotel?
    var listener: ListenerRegistration?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return listaHoteles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "celdaHotel", for: indexPath) as! HotelAdminCell

        let hotel = listaHoteles[indexPath.row]
        cell.configurarCelda(hotel: hotel)
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarHoteles()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tvHotel.delegate = self
        tvHotel.dataSource = self
        tvHotel.rowHeight = 120

    }
    func cargarHoteles() {
        listener?.remove()

        listener = db.collection("hoteles")
            .order(by: "nombre")
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    print("Error escuchando cambios: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.listaHoteles.removeAll()

                for document in documents {
                    let data = document.data()

                    let id = document.documentID
                    let codigo = data["codigo"] as? String ?? ""
                    let nombre = data["nombre"] as? String ?? ""
                    let ciudad = data["ciudad"] as? String ?? ""
                    let descripcion = data["descripcion"] as? String ?? ""
                    let servicio = data["servicio"] as? String ?? ""

                    let nuevoHotel = Hotel(
                        id: id,
                        codigo: codigo,
                        nombre: nombre,
                        descripcion: descripcion,
                        servicio: servicio,
                        ciudad: ciudad
                    )

                    self.listaHoteles.append(nuevoHotel)
                }

                DispatchQueue.main.async {
                    self.tvHotel.reloadData()
                }
            }
    }
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {

        let hotelAEnviar = listaHoteles[indexPath.row]

        performSegue(withIdentifier: "verDetalleHotel", sender: hotelAEnviar)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalleHotel" {
            if let destino = segue.destination as? HotelCrudAdminViewController
            {
                if let indexPath = tvHotel.indexPathForSelectedRow {
                    let hotelAEnviar = listaHoteles[indexPath.row]
                    destino.hotelRecibido = hotelAEnviar
                    print("✅ Enviando hotel: \(hotelAEnviar.nombre)")
                } else {
                    print(
                        "❌ No se encontró fila seleccionada en el momento del segue"
                    )
                }
            }
        }
    }

    @IBAction func btnAgregar(_ sender: UIButton) {
        performSegue(withIdentifier: "irAGenerarHotel", sender: self)
    }
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
