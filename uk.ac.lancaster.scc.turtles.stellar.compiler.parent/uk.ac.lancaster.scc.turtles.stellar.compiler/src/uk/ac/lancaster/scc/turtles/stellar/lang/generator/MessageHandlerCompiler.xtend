package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import org.eclipse.emf.ecore.resource.Resource
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.Role
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.MessageReference

class MessageHandlerCompiler {
	
	val String generatedPackage
	
	new(String generatedPackage) {
		this.generatedPackage = generatedPackage
	}
	
	def compile(Resource resource, Role role) {
		'''
		package «generatedPackage»;
		
		public interface «role.name.toFirstUpper»MessageHandler {
		
			«FOR reference : resource.allContents.toIterable.filter(MessageReference).filter[r | r.receiver.name.equals(role.name)] SEPARATOR '\n'»
			void handle«reference.name.toFirstUpper»(«role.name.toFirstUpper»Agent agent, «reference.name.toFirstUpper» message);
			«ENDFOR»
		}
		'''
	}
	
}