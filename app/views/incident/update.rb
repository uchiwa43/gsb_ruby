require 'Qt'

class Incident::Update < Widget::IncidentForm
	def initialize incident, attributes
		super
		setWindowTitle "GSB : Modifier incident"
    	show
	end
end