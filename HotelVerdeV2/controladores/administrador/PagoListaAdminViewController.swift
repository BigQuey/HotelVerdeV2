//
//  PagosListaAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit
import FirebaseFirestore

class PagoListaAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tvPagos: UITableView!
    
    var listaPagos: [Pago] = []
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvPagos.delegate = self
        tvPagos.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarPagos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    func cargarPagos() {
        let dao = PagoDAO()
        listener = dao.escucharPagos { [weak self] pagos in
            self?.listaPagos = pagos
            DispatchQueue.main.async {
                self?.tvPagos.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPagos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaPago", for: indexPath)
        
        let item = listaPagos[indexPath.row]
        
        let df = DateFormatter()
        df.dateStyle = .medium
        let fechaTexto = df.string(from: item.fecha)
        
        cell.textLabel?.text = "\(item.nombreCliente) - S/ \(item.monto)"
        cell.detailTextLabel?.text = "\(fechaTexto) - \(item.metodo)"
        
        return cell
    }
    
    @IBAction func btnNuevoPagoTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "irNuevoPago", sender: self)
    }
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
