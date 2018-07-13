package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import org.eclipse.emf.ecore.resource.Resource
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.Role
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.ReferenceParameter
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.MessageReference
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.Parameter

class ProtocolSchemaCompiler {
	
	val String protocolName
	val String generatedPackage
	val String libraryPackage
	
	new(String protocolName, String generatedPackage, String libraryPackage) {
		this.generatedPackage = generatedPackage
		this.libraryPackage = libraryPackage
		this.protocolName = protocolName;
	}
	
	def compile(Resource resource)  {
		'''
		package «generatedPackage»;
		
		import java.util.ArrayList;
		import java.util.List;
		
		public class «protocolName.toFirstUpper»Schema extends «libraryPackage».protocol.bspl.BSPLProtocolSchema {
		
		    private static final «protocolName.toFirstUpper»Schema INSTANCE;
		
		    static {
		        INSTANCE = new «protocolName.toFirstUpper»Schema(new «protocolName.toFirstUpper»ProtocolBuilder());
		    }
		
		    public static «protocolName.toFirstUpper»Schema instance() {
		        return INSTANCE;
		    }
		
		    private «protocolName.toFirstUpper»Schema(«protocolName.toFirstUpper»ProtocolBuilder builder) {
		        super(builder.name,
		                        builder.roles,
		                        builder.publicParameters,
		                        builder.privateParameters,
		                        builder.keyParameters,
		                        builder.inParameters,
		                        builder.outParameters,
		                        builder.nilParameters,
		                        builder.references,
		                        builder.relationNameForRoleBindings);
		    }
		
		    private static class «protocolName.toFirstUpper»ProtocolBuilder {
		
		        public final String name;
		        public final List<String> roles;
		        public final List<String> publicParameters;
		        public final List<String> privateParameters;
		        public final List<String> keyParameters;
		        public final List<String> inParameters;
		        public final List<String> outParameters;
		        public final List<String> nilParameters;
		        public final List<«libraryPackage».protocol.bspl.BSPLMessageSchema> references;
		        public final String relationNameForRoleBindings;
		
		        public PurchaseProtocolBuilder() {
		            name = "«protocolName»";
		            roles = new ArrayList<>();
		            «FOR role : resource.allContents.toIterable.filter(Role)»
		            roles.add(«protocolName.toFirstUpper»RoleName._«role.name».canonical());
		            «ENDFOR»
		            publicParameters = new ArrayList<>();
		            «FOR parameter : resource.allContents.toIterable.filter(Parameter)»
		            publicParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
		            «ENDFOR»
		            privateParameters = new ArrayList<>();
		            «FOR parameter : resource.privateParameters()»
		            privateParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter».canonical());
		            «ENDFOR»
		            keyParameters = new ArrayList<>();
		            «FOR parameter : resource.allContents.toIterable.filter(Parameter).filter[p | p.isKey]»
		            keyParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
					«ENDFOR»
					inParameters = new ArrayList<>();
					«FOR parameter : resource.allContents.toIterable.filter(Parameter).filter[p | p.adornment.equals("in")]»
					inParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
					«ENDFOR»
		            outParameters = new ArrayList<>();
					«FOR parameter : resource.allContents.toIterable.filter(Parameter).filter[p | p.adornment.equals("out")]»
					outParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
					«ENDFOR»
		            nilParameters = new ArrayList<>();
					«FOR parameter : resource.allContents.toIterable.filter(Parameter).filter[p | p.adornment.equals("nil")]»
					nilParameters.add(«protocolName.toFirstUpper»ParameterName._«parameter.name».canonical());
					«ENDFOR»
		            references = new ArrayList<>();
					«FOR reference : resource.allContents.toIterable.filter(MessageReference)»
					references.add(«reference.name.toFirstUpper»Schema.instance());
					«ENDFOR»
		            relationNameForRoleBindings = "«protocolName»_role_bindings";
		        }
		
		    }
		}'''
	}
	
	def privateParameters(Resource resource) {
		val publicParameters = resource.allContents.toIterable.filter(Parameter).map(p | p.name).toSet
		resource.allContents.toIterable.filter(ReferenceParameter).filter[p | !publicParameters.contains(p.name)].map(p | p.name).toSet
	}
	
}