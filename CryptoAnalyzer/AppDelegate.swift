//
//  AppDelegate.swift
//  CryptoAnalyzer
//
//  Created by Oscar Gutierrez C on 6/2/17.
//  Copyright © 2017 Trilobytes. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTextFieldDelegate {

	@IBOutlet weak var textToAnalyzeField: NSTextField!
	@IBOutlet weak var ResultsLabel: NSTextField!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

