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
        db.collection("hoteles").order(by: "nombre").getDocuments {
            snapshot, error in
            if let error = error {
                print("Error obteniendo hoteles: \(error)")
                return
            }

            self.listaHoteles.removeAll()

            guard let documents = snapshot?.documents else { return }

            for document in documents {
                let data = document.data()

                // Extraemos los datos con seguridad
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
                    ciudad: ciudad)

                self.listaHoteles.append(nuevoHotel)
            }

            DispatchQueue.main.async {
                // CORRECCIÓN: Aquí decías "tableView", pero tu variable es "tvHotel"
                self.tvHotel.reloadData()
            }
        }
    }
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "verDetalleHotel", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalleHotel" {
            if let destino = segue.destination as? HotelCrudAdminViewController
            {
                destino.hotelRecibido = hotelSeleccionado
            }
        }
    }

    
    @IBAction func btnAgregar(_ sender: UIButton) {
        performSegue(withIdentifier: "irAGenerarHotel", sender: self)
    }
}
