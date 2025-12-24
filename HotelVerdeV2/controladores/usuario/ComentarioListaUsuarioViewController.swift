
import UIKit
import FirebaseFirestore

class ComentarioListaUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // CONECTA ESTO A LA TABLA EN EL STORYBOARD
    
    @IBOutlet weak var tvComentarios: UITableView!

    var listaComentarios: [Comentario] = []
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tvComentarios.delegate = self
        tvComentarios.dataSource = self
        
    
        cargarDatos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
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
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaComentario", for: indexPath)
        
        let item = listaComentarios[indexPath.row]
        
        
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        let fechaTexto = df.string(from: item.fecha)
        
        
        cell.textLabel?.text = item.contenido
        cell.textLabel?.numberOfLines = 0 
        cell.detailTextLabel?.text = fechaTexto
        
        return cell
    }
    
    // MARK: - Navegación
    @IBAction func btnAgregarTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "irNuevoComentario", sender: self)
    }

    @IBAction func btnVolverTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
