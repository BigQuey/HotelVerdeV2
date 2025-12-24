
import UIKit

import UIKit
import FirebaseFirestore

class ReservaListaUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        cargarReservas()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    func cargarReservas() {
        let dao = ReservaDAO()
        // Reutilizamos la función de escuchar en tiempo real
        listener = dao.escucharReservas { [weak self] reservas in
            self?.listaReservas = reservas
            DispatchQueue.main.async {
                self?.tvReservas.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaReservas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaReservaUsuario", for: indexPath)
        
        let reserva = listaReservas[indexPath.row]
        
        
        let df = DateFormatter()
        df.dateStyle = .medium
        let inicio = df.string(from: reserva.fechaInicio)
        let fin = df.string(from: reserva.fechaFin)
        
        cell.textLabel?.text = reserva.nombreHotel
        cell.detailTextLabel?.text = "Del \(inicio) al \(fin)"
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reservaSeleccionada = listaReservas[indexPath.row]
        performSegue(withIdentifier: "verDetalleReserva", sender: reservaSeleccionada)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalleReserva" {
            if let destino = segue.destination as? ReservaDetalleUsuarioViewController {
                destino.reservaRecibida = sender as? Reserva
            }
        }
    }
    
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
