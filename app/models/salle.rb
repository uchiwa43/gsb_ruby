class Salle < ActiveRecord::Base

	has_many :incidents

 	def to_s
 		salle_nom
 	end

end