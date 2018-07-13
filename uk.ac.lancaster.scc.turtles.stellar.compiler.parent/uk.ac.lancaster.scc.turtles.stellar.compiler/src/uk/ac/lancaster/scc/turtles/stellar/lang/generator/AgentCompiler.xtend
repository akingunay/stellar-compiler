package uk.ac.lancaster.scc.turtles.stellar.lang.generator

import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.Role
import org.eclipse.emf.ecore.resource.Resource
import uk.ac.lancaster.scc.turtles.stellar.lang.bSPL.MessageReference
import java.util.List

class AgentCompiler {

	val String protocolName
	val String generatedPackage
	val String libraryPackage	

	new(String protocolName, String generatedPackage, String libraryPackage) {
		this.protocolName = protocolName
		this.generatedPackage = generatedPackage
		this.libraryPackage = libraryPackage
	}

	def compile(Resource resource, Role role, List<MessageReference> initMessages, List<MessageReference> nonInitMessages) {
		'''
		package «generatedPackage»;
		
		public class «role.name.toFirstUpper»Agent extends «libraryPackage».protocol.bspl.BSPLBasicAgent {
		
		    private final «role.name.toFirstUpper»MessageHandler messageHandler;
		
		    public «role.name.toFirstUpper»Agent(
		            «libraryPackage».agent.AgentIdentifier agentIdentifier, 
		            «role.name.toFirstUpper»MessageHandler messageHandler, 
		            «libraryPackage».agent.BasicAgentEventHandler eventHandler,
		            «libraryPackage».history.mysql.MySQLServerMetadata server
		            ) throws java.net.SocketException {
		        super(agentIdentifier,
		                «protocolName.toFirstUpper»Schema.instance(),
		                «libraryPackage».history.mysql.MySQLHistory.newMySQLHistory(server),
		                eventHandler);
		        this.messageHandler = messageHandler;
		    }
		
		    «FOR messageName : initMessages.filter[r | r.sender.name.equals(role.name)].map[r | r.name]»
		    public Enabled«messageName.toFirstUpper» retrieveEnabled«messageName.toFirstUpper»(«libraryPackage».agent.AgentIdentifier receiver) {
		        return new Enabled«messageName.toFirstUpper»(protocolAdapter, getAgentIdentifier(), receiver);
		    }
		    «ENDFOR»

			«FOR messageName : nonInitMessages.filter[r | r.sender.name.equals(role.name)].map[r | r.name]»
			public Enabled«messageName.toFirstUpper» retrieveEnabled«messageName.toFirstUpper»(String query) {
				return new Enabled«messageName.toFirstUpper»(retrieveEnabledMessage(«protocolName.toFirstUpper»MessageName._«messageName».canonical(), query));
			}
			
			public java.util.List<Enabled«messageName.toFirstUpper»> retrieveAllEnabled«messageName.toFirstUpper»s(String query) {
				java.util.List<«libraryPackage».protocol.bspl.BSPLEnabledMessage> enabledMessages = retrieveAllEnabledMessages(«protocolName.toFirstUpper»MessageName._«messageName».canonical(), query);
				java.util.List<Enabled«messageName.toFirstUpper»> enabled«messageName.toFirstUpper»s = new java.util.ArrayList<>();
				for («libraryPackage».protocol.bspl.BSPLEnabledMessage enabledMessage : enabledMessages) {
					enabled«messageName.toFirstUpper»s.add(new Enabled«messageName.toFirstUpper»(enabledMessage));
				}
				return enabled«messageName.toFirstUpper»s;
			}
		    «ENDFOR»
		
		    @Override
		    public void handleMessage(«libraryPackage».protocol.Message message) {
		        «libraryPackage».protocol.bspl.BSPLMessage bsplMessage = («libraryPackage».protocol.bspl.BSPLMessage) message;
		        if «FOR reference : resource.allContents.toIterable.filter(MessageReference).filter[r | r.receiver.name.equals(role.name)] SEPARATOR ' else if '»(bsplMessage.getName().equals(«reference.name.toFirstUpper»Schema.instance().getName())) {«'\n\t'»messageHandler.handle«reference.name.toFirstUpper»(this, new «reference.name.toFirstUpper»(bsplMessage));«'\n'»}«ENDFOR» else {
		
		        }
		    }
		
		}
		'''
	}
	
}