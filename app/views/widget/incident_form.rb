class Widget::IncidentForm < Window
def initialize incident, attributes
		super()
		@incident = incident
		@materiel = Materiel.all
		@salles = Salle.all
		@techniciens = Utilisateur.where("role_id IN (?)", [2, 4, 5])
		layout = Qt::VBoxLayout.new self
		@form  = Qt::FormLayout.new
		layout.addLayout @form

		@attributes = attributes
		@attributes.each_pair do |property, label|
			property = property.to_s
			if property == "materiel"#combobox
				field = @form_matos = Qt::ComboBox.new  #form_matos = nom du combobox
				@form_matos.addItem  '' , Qt::Variant.new(0) 
				@materiel.each do |matos| #afficher la liste déroulante
					@form_matos.addItem matos.libelle, Qt::Variant.new(matos.id_materiel) 
				end
				field.set_current_index @materiel.find_index @incident.materiel if @incident.materiel.present?

			elsif property == "salle" #combobox
				field = @form_salle = Qt::ComboBox.new  #form_matos = nom du combobox

				@salles.each do |salle| #afficher la liste déroulante
					@form_salle.addItem salle.salle_nom, Qt::Variant.new(salle.salle_id) 
				end
				field.set_current_index @salles.find_index @incident.salle if @incident.salle.present?

			elsif property == "description_incident"
				field = @form_description_incident = Qt::TextEdit.new
				@form_description_incident.set_text @incident.description_incident
				

			elsif property == "objet_de_la_demande"
				
				field = @form_objet_incident = Qt::LineEdit.new
				field.set_text @incident.objet_incident

			elsif property == "technicien" #combobox
				field = @form_technicien = Qt::ComboBox.new  #form_matos = nom du combobox

				@techniciens.each do |technicien| #afficher la liste déroulante
					@form_technicien.addItem technicien.nom_complet, Qt::Variant.new(technicien.id) 
				end

				user_index = @techniciens.find_index @incident.technicien
				
				field.set_current_index user_index if (@incident.technicien.present? && user_index)

			else
				puts property 
				instance_variable_set("@form_#{property}", Qt::LineEdit.new)
				field = instance_variable_get("@form_#{property}") 
				field.set_text(@incident.send("#{property}").to_s)
			end

			@form.addRow "#{label} :", field		
		end

		button_text = @incident.id.blank? ? 'Créer' : "Modifier"
		submit = Qt::PushButton.new button_text
		submit.connect SIGNAL :clicked do
    		save_incident unless @form_matos.item_data(@form_matos.current_index).to_i == 0
        end
		layout.add_widget submit
	end

	def save_incident
		@attributes.each do |property, label|
			property = property.to_s
			if property == "materiel"
				property = "materiel_id"
				value = @form_matos.item_data(@form_matos.current_index).to_i
			elsif property == "salle"
				property = "salle_id"
				value = @form_salle.item_data(@form_salle.current_index).to_i
 
			elsif property == "objet_incident"
				value = @form_objet_incident.text
			else 
				property = "description_incident"
				value = @form_description_incident.plainText
			end

			@incident.send("#{property}=", value) 
		end
		
		@incident.date_signalement = Time.now.strftime("%d-%m-%Y")

		@incident.etat = 2

		@incident.save

		IncidentController.new.index

		self.close
	end
end