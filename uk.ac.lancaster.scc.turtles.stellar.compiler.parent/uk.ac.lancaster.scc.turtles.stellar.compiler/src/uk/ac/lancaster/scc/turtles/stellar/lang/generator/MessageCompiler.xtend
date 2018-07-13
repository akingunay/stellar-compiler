package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.MessageReference

class MessageCompiler {
	
	val String generatedPackage
	val String libraryPackage
	
	new(String generatedPackage, String libraryPackage) {
		this.generatedPackage = generatedPackage
		this.libraryPackage = libraryPackage
	}
	
	def compile(MessageReference reference) {
		'''
		package «generatedPackage»;
		
		public class «reference.name.toFirstUpper» extends «libraryPackage».protocol.bspl.BSPLMessage {
		
		    «reference.name.toFirstUpper»(String jsonRepresentation) {
		        super(jsonRepresentation);
		
		    }
		
		    «reference.name.toFirstUpper»(«libraryPackage».protocol.bspl.BSPLMessage message) {
		        super(message);
		    }
		
		}
		'''
	}
	
}