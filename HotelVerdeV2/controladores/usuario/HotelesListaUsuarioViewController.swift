

import FirebaseFirestore
import UIKit

class HotelesListaUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tvHoteles: UITableView! // Asegúrate de conectarlo en el Storyboard
    
    
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
    
   
    func cargarHoteles() {
        
        dao.sincronizarHoteles { [weak self] hotelesRecibidos in
            self?.listaHoteles = hotelesRecibidos
            
            DispatchQueue.main.async {
                self?.tvHoteles.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaHoteles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaHotelUsuario", for: indexPath)
        
        let hotel = listaHoteles[indexPath.row]
        
        cell.textLabel?.text = hotel.nombre
     
        cell.detailTextLabel?.text = "\(hotel.ciudad) - \(hotel.servicio)"
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hotelSeleccionado = listaHoteles[indexPath.row]
        
        // Al tocar un hotel, vamos a la pantalla de crear reserva enviando el hotel
        performSegue(withIdentifier: "irAGenerarReserva", sender: hotelSeleccionado)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irAGenerarReserva" {
            // Asegúrate que el destino sea GeneraReservaUsuarioViewController
            if let destino = segue.destination as? GeneraReservaUsuarioViewController {
          
                destino.hotelRecibido = sender as? Hotel
            }
        }
    }
    
    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
