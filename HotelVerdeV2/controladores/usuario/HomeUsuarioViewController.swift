

import UIKit
import FirebaseAuth
class HomeUsuarioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnVerHotelesTapped(_ sender: UIButton) {
        navegar(alId: "HotelesListaUsuarioViewController")
    }

    @IBAction func btnMisReservasTapped(_ sender: UIButton) {
        navegar(alId: "ReservaListaUsuarioViewController")
    }

    @IBAction func btnComentariosTapped(_ sender: UIButton) {
        navegar(alId: "ComentarioListaUsuarioViewController")
    }

    @IBAction func btnCerrarSesionTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print("Error cerrando sesión")
        }
    }

    // Función auxiliar para navegar limpio
    func navegar(alId id: String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: id) {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
