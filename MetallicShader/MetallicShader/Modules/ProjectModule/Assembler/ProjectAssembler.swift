//
//  ProjectAssembler.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit

class ProjectAssembler: NSObject {
    @IBOutlet weak var viewController: UIViewController!
    
    //
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let view = viewController as? ProjectViewController else { return }
        let presenter = ProjectPresenter()
        let interactor = ProjectInteractor()
        let router = ProjectRouter()
        
        view.output = presenter
        
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        
        interactor.output = presenter
        
        router.viewController = view
    }
}
