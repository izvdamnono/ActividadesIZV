//
//  ActivityTableViewCell.swift
//  ActividadesIZV
//
//  Created by Fernando on 29/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var ivActividad: UIImageView!
    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var lbResumen: UILabel!
    @IBOutlet weak var lbDepartamento: UILabel!
    @IBOutlet weak var lbProfesor: UILabel!
    @IBOutlet weak var lbGrupo: UILabel!
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbInicio: UILabel!
    
    @IBOutlet weak var lbFin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
