//
//  SafariExtensionHandler.swift
//  Ctcu Extension
//
//  Created by Nekilc on 2022/12/12.
//

import SafariServices

struct Page:Codable{
    var title:String
    var link:String
}

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }

    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
        window.getActiveTab { tab in
            tab?.getActivePage(completionHandler: { page in
                page?.getPropertiesWithCompletionHandler({ props in
                    
                    
                    let page = Page(title: props?.title ?? "", link: props?.url?.absoluteString ?? "")
                    
                    NSLog(page.link)
                    
                    
                    let jsonencode = JSONEncoder()
                    if #available(macOSApplicationExtension 10.15, *) {
                        jsonencode.outputFormatting = .withoutEscapingSlashes.union(.prettyPrinted)
                    } else {
//                        jsonencode.outputFormatting = .prettyPrinted
                    }
                    
                    let jsonData  = try? jsonencode.encode(page)
                    let jsonString = String(data: jsonData!, encoding: .utf8)!

                    
                    NSLog(jsonString)
                    
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(jsonString, forType: NSPasteboard.PasteboardType.string)
                    
                })
            })
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
