//
//  AppRouter.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

final class AppRouter {
    
    static let shared = AppRouter()
    
    private var window: UIWindow?
    
    func configure(window: UIWindow?) {
        self.window = window
    }
    
    func presentMoviesListScreen() {
        
        let navController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! UINavigationController
        let movieListView = navController.topViewController as! MoviesListViewInterface
        MoviesListWireframe.assemble(dependencies: DIContainer.shared, forView: movieListView)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
