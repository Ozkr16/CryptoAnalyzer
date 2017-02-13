//
//  TableViewControllerExtensions.swift
//  CryptoAnalyzer
//
//  Created by Oscar Gutierrez C on 12/2/17.
//  Copyright © 2017 Trilobytes. All rights reserved.
//

import Cocoa


extension ViewController : NSTableViewDataSource {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return tableViewValueCollection.count
	}
}

extension ViewController : NSTableViewDelegate {
	
	enum CellID : String {
		case Key = "KeyCellID"
		case Value = "ValueCellID"
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let valueWithingCell : String
		let identifier : String
		if let columnaBuscada = tableColumn{
			switch columnaBuscada.identifier {
			case keyColumn.identifier:
				valueWithingCell = tableViewKeyCollection[row]
				identifier = CellID.Key.rawValue
			case valueColumn.identifier:
				valueWithingCell = tableViewValueCollection[row]
				identifier = CellID.Value.rawValue
			default:
				return nil
			}
		}else{
			return nil
		}
		
		if let cell = keyValueTable.make(withIdentifier: identifier, owner: nil) as? NSTableCellView{
			cell.textField?.stringValue = valueWithingCell
			return cell
		}
		
		return nil
	}
	
	
}
