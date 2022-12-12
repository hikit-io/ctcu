//
//  SafariExtensionViewController.swift
//  Ctcu Extension
//
//  Created by Nekilc on 2022/12/12.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
