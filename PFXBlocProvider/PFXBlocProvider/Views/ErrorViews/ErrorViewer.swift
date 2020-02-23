//
//  ErrorAlertViewController.swift
//  PFXBlocProvider
//
//  Created by succorer on 22/02/2020.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import UIKit

class ErrorViewer {
    static let shared = ErrorViewer()
    func show(error: NSError) {
        let messageKey = BPError.messageKey(value: error.code)
        let title = NSLocalizedString("common_title", comment: "")
        let buttonConfirmTitle = NSLocalizedString("button_confirm_title", comment: "")
        let viewController = UIApplication.shared.windows.first!.rootViewController
        let alertController = UIAlertController(title: title, message: messageKey, preferredStyle: .alert)
        let alert = UIAlertAction(title: buttonConfirmTitle, style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alert)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
