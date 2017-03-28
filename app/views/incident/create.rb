require 'Qt'

class Incident::Create < Widget::IncidentForm
	def initialize incident, attributes
		super
		setWindowTitle "GSB : Créer incident"
    	show
	end
end