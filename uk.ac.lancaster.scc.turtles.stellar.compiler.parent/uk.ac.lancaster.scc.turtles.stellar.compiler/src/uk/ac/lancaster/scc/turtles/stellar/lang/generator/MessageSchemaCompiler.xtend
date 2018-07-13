package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.MessageReference
import java.util.Set

class MessageSchemaCompiler {
	
	val String protocolName;
	val String generatedPackage
	val String libraryPackage
	val Set<String> protocolKeys

	new(String protocolName, String generatedPackage, String libraryPackage, Set<String> protocolKeys) {
		this.protocolName = protocolName;
		this.generatedPackage = generatedPackage
		this.libraryPackage = libraryPackage
		this.protocolKeys = protocolKeys
	}

	def compile(MessageReference messageReference)  {
		'''
		package «generatedPackage»;
		
		import java.util.ArrayList;
		import java.util.List;
		
		public class «messageReference.name.toFirstUpper»Schema extends «libraryPackage».protocol.bspl.BSPLMessageSchema {
		
		    private static final «messageReference.name.toFirstUpper»Schema INSTANCE;
		
		    static {
		        INSTANCE = new «messageReference.name.toFirstUpper»Schema(new «messageReference.name.toFirstUpper»SchemaBuilder());
		    }
		
		    public static «messageReference.name.toFirstUpper»Schema instance() {
		        return INSTANCE;
		    }
		
		    private «messageReference.name.toFirstUpper»Schema(«messageReference.name.toFirstUpper»SchemaBuilder builder) {
		        super(builder.name,
		        		builder.senderRole,
		        		builder.receiverRole,
		        		builder.parameters,
		        		builder.keyParameters,
		                builder.inParameters,
		                builder.outParameters,
		                builder.nilParameters);
		    }
		
		    private static class «messageReference.name.toFirstUpper»SchemaBuilder {
		
		        public final String name;
		        public final String senderRole;
		        public final String receiverRole;
		        public final List<String> parameters;
		        public final List<String> keyParameters;
		        public final List<String> inParameters;
		        public final List<String> outParameters;
		        public final List<String> nilParameters;
		
		        public «messageReference.name.toFirstUpper»SchemaBuilder() {
		            name = «protocolName.toFirstUpper»MessageName._«messageReference.name».canonical();
		            senderRole = «protocolName.toFirstUpper»RoleName._«messageReference.sender.name».canonical();
		            receiverRole = «protocolName.toFirstUpper»RoleName._«messageReference.receiver.name».canonical();
		            parameters = new ArrayList<>();
		            «FOR parameter : messageReference.parameters.referenceParameters»
		            parameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
		            «ENDFOR»
		            keyParameters = new ArrayList<>();
					«FOR parameter : messageReference.parameters.referenceParameters.filter[p | protocolKeys.contains(p.name)]»
					keyParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
					«ENDFOR»
		            inParameters = new ArrayList<>();
		            «FOR parameter : messageReference.parameters.referenceParameters.filter[p | p.adornment.equals("in")]»
		            inParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
		            «ENDFOR»
		            outParameters = new ArrayList<>();
		            «FOR parameter : messageReference.parameters.referenceParameters.filter[p | p.adornment.equals("out")]»
		            outParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
		            «ENDFOR»
		            nilParameters = new ArrayList<>();
		            «FOR parameter : messageReference.parameters.referenceParameters.filter[p | p.adornment.equals("nil")]»
		            nilParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
					«ENDFOR»
		        }
		
		    }
		
		}
		'''
	}
}