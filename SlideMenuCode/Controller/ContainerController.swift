//
//  ContainerController.swift
//  SlideMenuCode
//
//  Created by Jair Moreno Gaspar on 2/14/19.
//  Copyright © 2019 Jair Moreno Gaspar. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    
    //MARK: -Properties
    
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    private lazy var FirstObject: InboxController =
    {
        // Instantiate View Controller
        let viewController = InboxController()
        
        // Add View Controller as Child View Controller
        self.addChild(viewController)
        return viewController
    }()
    
    //MARK: -Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeController()
    }
    
    //Cambiar status bar a blanco
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: -Handlers
    
    func configureHomeController(){
        let homeController = HomeController()
        homeController.homeControllerDelegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
        
    }

    func configureMenuController(){
        //Esto nos asegura que solo se agregará una vez el menu
        if menuController == nil{
            menuController = MenuController()
            menuController.homeControllerDelegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            print("did add menuController")
        }
    }
    
    func showMenuController(shouldExpand: Bool, menuOption: MenuOption?){
        
        if shouldExpand {
            //showMenu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
                
            }, completion: nil)
        } else {
            //hideMenu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
            
        }
        
    }

    func didSelectMenuOption(menuOption: MenuOption){
        switch menuOption {
        case .Profile:
            print("show profile")
            
            //Quitamos los controllers para que no se agreguen cada que se despliegue el menu y evitar desborde de memoria
            removeChildControllers()
            
            //Agregamos el menu
            addMenuController()
            
            //Agregamos el controlador actual
            let currentController = HomeController()
            currentController.homeControllerDelegate = self
            centerController = UINavigationController(rootViewController: currentController)
            
            view.addSubview(centerController.view)
            addChild(centerController)
            centerController.didMove(toParent: self)
            
        case .Inbox:
            print("show Inbox")
            
            //Quitamos los controllers para que no se agreguen cada que se despliegue el menu y evitar desborde de memoria
            removeChildControllers()
            
            //Agregamos el menu
            addMenuController()
            
            //Agregamos el controlador actual
            let currentController = InboxController()
            currentController.inboxControllerDelegate = self
            centerController = UINavigationController(rootViewController: currentController)
            
            view.addSubview(centerController.view)
            addChild(centerController)
            centerController.didMove(toParent: self)
            
   
            
            
        case .Notifications:
            print("show Notifications")
        case .Settings:
            print("show Settings")
            
        }
    }
    
    func removeChildControllers(){
        self.children.forEach({ (controller) in
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            
        })
    }
    
    func addMenuController(){
        view.insertSubview(menuController.view, at: 0)
        addChild(menuController)
        menuController.didMove(toParent: self)
        print("did add menuController")
    }
    
}


extension ContainerController: HomeControllerDelegate{
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded{
            configureMenuController()
        }
        
        isExpanded.toggle()
        showMenuController(shouldExpand: isExpanded, menuOption: menuOption)
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
