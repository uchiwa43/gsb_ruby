class Materiel < ActiveRecord::Base
	self.inheritance_column = "inheritance_type"
	has_many :incidents

 	def to_s
 		libelle
 	end

 	def libelle
 		"#{type} - #{marque} - #{modele}"
 	end
end