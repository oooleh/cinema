//
//  Alertable.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

protocol Alertable {}
extension Alertable where Self: UIViewController {
    
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertControllerStyle = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
