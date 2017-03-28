class Incident < ActiveRecord::Base

	belongs_to :materiel
	belongs_to :salle
	belongs_to :technicien, class_name: "Utilisateur"
	belongs_to :demandeur, class_name: "Utilisateur"


end