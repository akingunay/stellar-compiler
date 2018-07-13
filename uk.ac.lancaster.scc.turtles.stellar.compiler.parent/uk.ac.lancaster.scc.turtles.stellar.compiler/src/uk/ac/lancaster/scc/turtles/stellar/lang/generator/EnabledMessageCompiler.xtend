package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.MessageReference

class EnabledMessageCompiler {
	
	val String protocolName
	val String generatedPackage
	val String libraryPackage
	
	new(String protocolName, String generatedPackage, String libraryPackage) {
		this.protocolName = protocolName
		this.generatedPackage = generatedPackage
		this.libraryPackage = libraryPackage
	}
	
	def compileInit(MessageReference reference) {
		'''
		package «generatedPackage»;
		
		public class Enabled«reference.name.toFirstUpper» extends «libraryPackage».protocol.bspl.BSPLEnabledMessage {
		
		    Enabled«reference.name.toFirstUpper»(
		    		«libraryPackage».protocol.ProtocolAdapter protocolAdapter,
		    		«libraryPackage».agent.AgentIdentifier sender, 
		    		«libraryPackage».agent.AgentIdentifier receiver) {
				super(protocolAdapter, new «libraryPackage».protocol.bspl.BSPLMessage(«protocolName.toFirstUpper»MessageName._«reference.name».canonical(), sender, receiver, new java.util.HashMap<String, String>()));
		    }
		
		    public void send(«FOR parameter : reference.parameters.referenceParameters.filter[p | p.adornment.equals("out")] SEPARATOR ', '»String _«parameter.name»«ENDFOR») {
		        «FOR parameter : reference.parameters.referenceParameters.filter[p | p.adornment.equals("out")]»
		        if (_«parameter.name» == null) {
		            throw new NullPointerException("Binding of parameter '_«parameter.name»' cannot be null");
		        }
		        «ENDFOR»
		        «FOR parameter : reference.parameters.referenceParameters.filter[p | p.adornment.equals("out")]»
		        setParameterBinding(«protocolName»ParameterName._«parameter.name».canonical(), _«parameter.name»);
		        «ENDFOR»
		        send();
		    }
		}
		'''
	}
	
	
	def compileNonInit(MessageReference reference) {
		'''
		package «generatedPackage»;
		
		public class Enabled«reference.name.toFirstUpper» extends «libraryPackage».protocol.bspl.BSPLEnabledMessage {
		
		    public Enabled«reference.name.toFirstUpper»(«libraryPackage».protocol.bspl.BSPLEnabledMessage message) {
		        super(message);
		    }
		
		    public void send(«FOR parameter : reference.parameters.referenceParameters.filter[p | p.adornment.equals("out")] SEPARATOR ','»String _«parameter.name»«ENDFOR») {
		        «FOR parameter : reference.parameters.referenceParameters.filter[p | p.adornment.equals("out")]»
		        if (_«parameter.name» == null) {
		            throw new NullPointerException("Binding of parameter '_«parameter.name»' cannot be null");
		        }
		        «ENDFOR»
		        «FOR parameter : reference.parameters.referenceParameters.filter[p | p.adornment.equals("out")]»
		        setParameterBinding(«protocolName»ParameterName._«parameter.name».canonical(), _«parameter.name»);
		        «ENDFOR»
		        send();
		    }
		}
		'''
	}
}