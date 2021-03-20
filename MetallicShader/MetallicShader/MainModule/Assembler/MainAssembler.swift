//
//  MainAssembler.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit

class MainAssembler: NSObject {
    @IBOutlet weak var viewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let view = viewController as? MainViewController else { return }
        let presenter = MainPresenter()
        let router = MainRouter()
        
        view.output = presenter
        
        presenter.router = router
        
        router.view = view
    }
}
