package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import org.eclipse.emf.ecore.resource.Resource
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.Role

class RoleNameEnumCompiler {
	
	val String protocolName
	val String generatedPackage
	
	new(String protocolName, String generatedPackage) {
		this.protocolName = protocolName
		this.generatedPackage = generatedPackage
	}
	
	def compile(Resource resource) {
		'''
		package «generatedPackage»;
		
		public enum «protocolName.toFirstUpper»RoleName {
		
			«FOR role : resource.allContents.toIterable.filter(Role).map[r | r.name].toSet SEPARATOR ',\n' AFTER ';'»_«role»("«role»")«ENDFOR»
		
		    private final String canonical;
		
		    private «protocolName.toFirstUpper»RoleName(String canonical) {
		        this.canonical = canonical;
		    }
		
		    public String canonical() {
		        return canonical;
		    }
		}
		'''
	}}