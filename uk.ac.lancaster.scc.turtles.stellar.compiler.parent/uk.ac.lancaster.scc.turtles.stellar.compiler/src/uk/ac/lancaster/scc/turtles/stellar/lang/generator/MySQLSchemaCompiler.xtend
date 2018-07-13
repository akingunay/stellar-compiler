package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import org.eclipse.emf.ecore.resource.Resource
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.Role
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.MessageReference
import java.util.Set

class MySQLSchemaCompiler {
	
	val VARCHAR_SIZE = "60"
	val String protocolName
	val Set<String> protocolKeys
	
	new(String protocolName, Set<String> protocolKeys) {
		this.protocolName = protocolName
		this.protocolKeys = protocolKeys
	}
	
	def compile(Resource resource, Role role) {
		'''
		# Execute the following MySQL statements in the 
		# database of each agent who enacts «role.name».
		
		«FOR reference : resource.allContents.toIterable.filter(MessageReference).filter[r | r.sender.name.equals(role.name) || r.receiver.name.equals(role.name)] SEPARATOR "\n"»
		create table if not exists «reference.name» (
			sender varchar(«VARCHAR_SIZE») not null,
			receiver varchar(«VARCHAR_SIZE») not null,
			«FOR parameter : reference.parameters.referenceParameters»
			«parameter.name» varchar(«VARCHAR_SIZE») not null,
			«ENDFOR»
		    primary key («FOR paramter : reference.parameters.referenceParameters.filter[p | protocolKeys.contains(p.name)] SEPARATOR ', '»«paramter.name»«ENDFOR»)
		);
		«ENDFOR»
		
		create table if not exists «protocolName»_role_bindings (
		    «FOR key : protocolKeys»
		    «key» varchar(«VARCHAR_SIZE») not null,
		    «ENDFOR»
		    «FOR roleName : resource.allContents.toIterable.filter(Role).map(r | r.name)»
		    «roleName» varchar(«VARCHAR_SIZE») not null,
		    «ENDFOR»
		    primary key («FOR key : protocolKeys SEPARATOR ', '»«key»«ENDFOR»)
		);
		'''
	}
}