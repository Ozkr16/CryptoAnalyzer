//
//  ViewController.swift
//  CryptoAnalyzer
//
//  Created by Oscar Gutierrez C on 6/2/17.
//  Copyright © 2017 Trilobytes. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextDelegate, NSTextFieldDelegate {

	@IBOutlet weak var textToAnalyzeField: NSTextField!
	@IBOutlet weak var ResultsLabel: NSTextField!
	@IBOutlet weak var bigramasLabel: NSTextFieldCell!
	@IBOutlet weak var trigramasLabel: NSTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		textToAnalyzeField.delegate = self
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	override func controlTextDidChange(_ notification: Notification) {
		let textField = notification.object as! NSTextField
		
		let frequencyResults = calculateFrequencyOf(stringToAnalyze: textField.stringValue)
		let formatedString = formatFrequency(results: frequencyResults)
		self.ResultsLabel.stringValue = formatedString
		
		let bigramFrequency = calculateNgramFrequencyOf(stringToAnalyze: textField.stringValue, withNgramLength: 2)
		let formatedBigrams = formatFrequencyAlt(results: bigramFrequency)
		
		let trigramFrequency = calculateNgramFrequencyOf(stringToAnalyze: textField.stringValue, withNgramLength: 3)
		let formatedTrigrams = formatFrequencyAlt(results: trigramFrequency)
		
		self.bigramasLabel.stringValue = "Los 20 Bigramas Más Frecuentes: \n\(formatedBigrams)"
		self.trigramasLabel.stringValue = "Los 20 Trigramas Más Frecuentes: \n\(formatedTrigrams)"
	}
	
	
	func calculateFrequencyOf(stringToAnalyze: String) -> [(String, Double)] {
		let symbols = stringToAnalyze.lowercased().characters.map{String($0)}
		
		var results =  [(String, Double)]()
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
	
	func formatFrequency(results: [(String, Double)]) -> String {
		var parcialResult : String = ""
		let numeroItems = Double(textToAnalyzeField.stringValue.characters.count)
		
		for (letra, frecuencia) in results.sorted(by: {$0.1 > $1.1})
		{
			parcialResult += "Símbolo: \(letra) | Frecuencia: \((frecuencia/numeroItems)*100 ) \n"
		}
		return parcialResult
	}
	
	func formatFrequencyAlt(results: [(String, Int)]) -> String {
		var parcialResult : String = ""
		
		var numeroItemsProcesados = 0
		for (letra, frecuencia) in results.sorted(by: {$0.1 > $1.1})
		{
			parcialResult += "Símbolo: \(letra) | Frecuencia: \((frecuencia) ) \n"
			numeroItemsProcesados += 1
			if numeroItemsProcesados >= 35 {
				break
			}
		}
		return parcialResult
	}
	
	
	func calculateNgramFrequencyOf(stringToAnalyze: String, withNgramLength: Int) -> [(String, Int)] {
		let symbols = stringToAnalyze.lowercased().characters.map{String($0)}
		
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
}

