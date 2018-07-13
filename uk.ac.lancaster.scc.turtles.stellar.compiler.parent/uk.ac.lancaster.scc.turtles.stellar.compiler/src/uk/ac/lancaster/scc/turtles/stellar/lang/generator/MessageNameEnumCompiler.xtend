package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import org.eclipse.emf.ecore.resource.Resource
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.MessageReference

class MessageNameEnumCompiler {
	
	val String protocolName
	val String generatedPackage
	
	new(String protocolName, String generatedPackage) {
		this.protocolName = protocolName
		this.generatedPackage = generatedPackage
	}
	
	def compile(Resource resource) {
		'''
		package «generatedPackage»;
		
		public enum «protocolName.toFirstUpper»MessageName {
		
			«FOR reference : resource.allContents.toIterable.filter(MessageReference) SEPARATOR ',\n' AFTER ';'»_«reference.name»("«reference.name»")«ENDFOR»
		
		    private final String canonical;
		
		    private «protocolName.toFirstUpper»MessageName(String canonical) {
		        this.canonical = canonical;
		    }
		
		    public String canonical() {
		        return canonical;
		    }
		}
		'''
	}
}