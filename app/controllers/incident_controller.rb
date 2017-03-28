require 'Qt'

class IncidentController < Controller

	def index 
		Incident::Index.new 
	end
	
	def create
		incident = Incident.new
		fields = {
			materiel: "Materiel demandé", 
			objet_incident: "Objet de l'incident" ,
			salle: "Salle", 
			description_incident: "Description"
		}
		Incident::Create.new incident, fields
	end

	def update incident

		fields = {
			etat: "Etat", 
			materiel: "Materiel demandé", 
			objet_incident: "Objet de l'incident" ,
			description_incident: "Description",
			solution_incident: "Solution incident",
			date_signalement: "Date de signalement", 
			date_intervention: "Date d'intervention",
			salle: "Salle", 
			technicien: "Technicien", 
			demandeur: "Demandeur",
			niveau_urgence: "Niveau d'urgence", 
			niveau_complexite: "Niveau de complexité"
		}

		Incident::Update.new incident, fields
	end

	
end