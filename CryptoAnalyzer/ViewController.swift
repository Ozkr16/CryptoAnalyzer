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
	@IBOutlet weak var subtextsLabel: NSTextField!
	
	var tableViewKeyCollection : [String] = []
	var tableViewValueCollection : [String] = []
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		textToAnalyzeField.delegate = self
		tableViewKeyCollection = ["Indice Coincidencia", "Kasinsky", "Babage"]
		tableViewValueCollection = ["", "", ""]
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
		let symbols = textField.stringValue.lowercased().replacingOccurrences(of: " ", with: "").characters.map{String($0)}
		
		let rawResults = calculateNgramFrequency(of: symbols, withNgramLength: 1)
		let frequencyResults = rawResults.map{(simbolo, frecuencia) in return (simbolo, frecuencia/numeroItems*100)}
		let formatedString = formatFrequency(results: frequencyResults, taking: frequencyResults.count)
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
		
		let subtextos = divideTextInSubtext(texto: textField.stringValue, numeroTextos: 5)
		let formattedSubtexts = formatSubtexts(subtextos: subtextos)
		self.subtextsLabel.stringValue = formattedSubtexts
		
		for tN in subtextos {
			let letrasSubN = tN.lowercased().replacingOccurrences(of: " ", with: "").characters.map{String($0)}
			let freqSubN = calculateNgramFrequency(of: letrasSubN, withNgramLength: 1).sorted(by: {$0.1 > $1.1})
			
			//Por hacer: revisar cada uno de los subtextos, y encontrar todos los indices en que aparece la letra
			// dada por el for. Con la lista de indices, buscar el indice anterior y posterior en los subtextos anterior y posterior
			//respectivamente. Hacer append de esos letras en un string, por izquierda y por derecha.
			
			
			//for letra in freqSubN {
			//	tN.rangeOfString(
			//}
		}
	}
	
	func calculateNgramFrequency(of symbols: [String], withNgramLength: Int) -> [(String, Double)] {
		
		var results =  [(String, Double)]()
		let conteo: Int = symbols.count - withNgramLength
		var index = 0
		
		while(index <= conteo){
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
	
	func formatFrequency(results: [(String, Double)], taking maxNumberOfItems: Int) -> String {
		var parcialResult : String = ""
		
		var numeroItemsProcesados = 0
		for (letra, frecuencia) in results.sorted(by: {$0.1 > $1.1})
		{

			
			parcialResult += "\(letra) : \(frecuencia)\n"
			numeroItemsProcesados += 1
			if numeroItemsProcesados >= maxNumberOfItems {
				break
			}
		}
		return parcialResult
	}
	
	func calculateCoincidenceIndex(of frequency: [(String, Double)], with textLeght: Int ) -> Double {
		
		var acumular: Double = 0
		for (_, frecuencia) in frequency {
			acumular += frecuencia*(frecuencia-1)
		
		}
		return acumular/Double(textLeght*(textLeght-1))
	}
	
	func divideTextInSubtext(texto: String, numeroTextos: Int) -> [String]{
		let caracteres = texto.lowercased().replacingOccurrences(of: " ", with: "").characters.map{String($0)}
		var currentT = 0;
		var textos = [String](repeating: "", count: numeroTextos)
		
		for letra in caracteres {
			
			textos[currentT] += letra
			currentT += 1
			
			if currentT % numeroTextos == 0
			{
				currentT = 0
			}
		}
		return textos
	}
	
	func formatSubtexts(subtextos : [String]) -> String {
		var formateado: String = ""
		var contador = 0
		for sub in subtextos {
			formateado += "T\(contador): \(sub) \n"
			contador += 1
		}
		return formateado
	}

}
