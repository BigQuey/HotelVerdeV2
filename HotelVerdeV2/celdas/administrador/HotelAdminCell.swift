//
//  HotelCell.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit

class HotelAdminCell: UITableViewCell {

    @IBOutlet weak var lblNommbre: UILabel!
    
    @IBOutlet weak var lblCiudad: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configurarCelda(hotel: Hotel) {
        lblNommbre.text = hotel.nombre
        lblCiudad.text = "Ciudad: \(hotel.ciudad) - Cod: \(hotel.codigo)"
    }
}
