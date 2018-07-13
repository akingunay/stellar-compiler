package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import org.eclipse.emf.ecore.resource.Resource
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.ReferenceParameter

class ParameterNameEnumCompiler {
	
	val String protocolName
	val String generatedPackage
	
	new(String protocolName, String generatedPackage) {
		this.protocolName = protocolName
		this.generatedPackage = generatedPackage
	}
	
	def compile(Resource resource) {
		'''
		package «generatedPackage»;
		
		public enum «protocolName.toFirstUpper»ParameterName {
		
			«FOR parameter : resource.allContents.toIterable.filter(ReferenceParameter).map[p | p.name].toSet SEPARATOR ',\n' AFTER ';'»_«parameter»("«parameter»")«ENDFOR»
		
		    private final String canonical;
		
		    private «protocolName.toFirstUpper»ParameterName(String canonical) {
		        this.canonical = canonical;
		    }
		
		    public String canonical() {
		        return canonical;
		    }
		}
		'''
	}
	
}