//
//  ViewController.swift
//  CryptoAnalyzer
//
//  Created by Oscar Gutierrez C on 6/2/17.
//  Copyright © 2017 Trilobytes. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextDelegate,
					  NSTextFieldDelegate {

	@IBOutlet weak var textToAnalyzeField: NSTextField!
	@IBOutlet weak var ResultsLabel: NSTextField!
	@IBOutlet weak var bigramasLabel: NSTextFieldCell!
	@IBOutlet weak var trigramasLabel: NSTextField!
	@IBOutlet weak var keyValueTable: NSTableView!
	@IBOutlet weak var keyColumn: NSTableColumn!
	@IBOutlet weak var valueColumn: NSTableColumn!
	
	var tableViewKeyCollection : [String] = []
	var tableViewValueCollection : [String] = []
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		textToAnalyzeField.delegate = self
		tableViewKeyCollection = ["Indice Coincidencia", "Kasinsky", "Babage"]
		tableViewValueCollection = ["FakeIndex1234", "Kasinsky1234", "Babage1234"]
		keyValueTable.delegate = self
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	override func controlTextDidChange(_ notification: Notification) {
		let textField = notification.object as! NSTextField
		
		let numeroItems = Double(textToAnalyzeField.stringValue.characters.count)
		let symbols = textField.stringValue.lowercased().characters.map{String($0)}
		
		let rawResults = calculateFrequency(of: symbols)
		let frequencyResults = rawResults.map{(simbolo, frecuencia) in return (simbolo, (Double(frecuencia)/numeroItems*100))}
		let formatedString = formatFrequency(results: frequencyResults)
		self.ResultsLabel.stringValue = formatedString
		
		let IC = calculateCoincidenceIndex(of: rawResults, with: symbols.count)
		tableViewValueCollection[0] = "\(IC)"
		keyValueTable.reloadData()
		
		let bigramFrequency = calculateNgramFrequency(of: symbols, withNgramLength: 2)
		let formatedBigrams = formatFrequency(results: bigramFrequency, taking: 35)
		
		let trigramFrequency = calculateNgramFrequency(of: symbols, withNgramLength: 3)
		let formatedTrigrams = formatFrequency(results: trigramFrequency, taking: 35)
		
		self.bigramasLabel.stringValue = "Los 20 Bigramas Más Frecuentes: \n\(formatedBigrams)"
		self.trigramasLabel.stringValue = "Los 20 Trigramas Más Frecuentes: \n\(formatedTrigrams)"
		
	}
	
	
	func calculateFrequency(of symbols: [String]) -> [(String, Int)] {
		
		var results =  [(String, Int)]()
		for letra in symbols {
			if let indiceLetra = results.index(where: {(simbolo, frecuencia) in simbolo == letra}){
				let elemento = results.remove(at: indiceLetra)
				results.append((elemento.0, elemento.1 + 1 ))
			}else{
				results.append((letra, 1))
			}
		}
		return results
	}
	
	func calculateNgramFrequency(of symbols: [String], withNgramLength: Int) -> [(String, Int)] {
		
		var results =  [(String, Int)]()
		let conteo: Int = symbols.count - withNgramLength
		var index = 0
		
		while(index < conteo){
			var index2 = 0
			var nGramaBuscado = ""
			while(index2 < withNgramLength){
				nGramaBuscado += symbols[index + index2]
				index2 += 1
			}
			
			if let indiceElementoBuscado = results.index(where:{ (nGrama,valor) in nGrama == nGramaBuscado}) {
				var elementoAModificar = results.remove(at: indiceElementoBuscado)
				elementoAModificar.1 += 1
				results.append(elementoAModificar)
			}else{
				results.append((nGramaBuscado, 1))
			}
			
			index += 1
		
		}
		
		results.sort(by: {$0.1 > $1.1})
		
		return results
	}
	
	func formatFrequency(results: [(String, Double)]) -> String {
		var parcialResult : String = ""
		
		
		for (letra, frecuencia) in results.sorted(by: {$0.1 > $1.1})
		{
			parcialResult += "Símbolo: \(letra) | Frecuencia: \(frecuencia) \n"
		}
		return parcialResult
	}
	
	func formatFrequency(results: [(String, Int)], taking maxNumberOfItems: Int) -> String {
		var parcialResult : String = ""
		
		var numeroItemsProcesados = 0
		for (letra, frecuencia) in results.sorted(by: {$0.1 > $1.1})
		{
			parcialResult += "Símbolo: \(letra) | Frecuencia: \((frecuencia) ) \n"
			numeroItemsProcesados += 1
			if numeroItemsProcesados >= maxNumberOfItems {
				break
			}
		}
		return parcialResult
	}
	
	func calculateCoincidenceIndex(of frequency: [(String, Int)], with textLeght: Int ) -> Double {
		
		var acumular: Int = 0
		for (_, frecuencia) in frequency {
			acumular += frecuencia*(frecuencia-1)
		
		}
		return Double(acumular)/Double(textLeght*(textLeght-1))
	}
}
