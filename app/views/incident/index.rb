require 'Qt'
require 'pathname'

class Incident::Index < Window

	attr_reader :incident_panel, :incident_display, :incident_list, :panel_width, :list_width
	attr_accessor :selected_incident

	def initialize
		super()
		@selected_incident = Incident.first 
		@layout = Qt::VBoxLayout.new self
		@incident_panel  = Qt::Widget.new 

		add_top_menu_bar
		
		add_incident_list
		
		display_window
		add_incident_panel
	end
	
	def add_top_menu_bar
		@menu_bar = Qt::MenuBar.new
		#@menu_bar.setSizePolicy(Qt::SizePolicy::Fixed, Qt::SizePolicy::Fixed)
		
		@layout.add_widget @menu_bar
		
		@file  = @menu_bar.add_menu "fichier"
		@tools = @menu_bar.add_menu "outils"
		exit   = Qt::Action.new "fermer", self
		exit.connect SIGNAL :triggered do
			$qApp.quit
		end
		@file.add_action exit

		add_incident = Qt::Action.new "ajouter incident", self
		add_incident.connect SIGNAL :triggered do
			IncidentController.new.create
			self.close
		end
		@tools.add_action add_incident

	end

	def add_incident_list

		puts current_user.is? ["ROLE_TECHNICIEN", "ROLE_RESPONSABLE"]
		@incident_list = Widget::IncidentsTable.new({
							id: "Id", 
						etat: 	"Etat", 
					materiel: 	"Materiel", 
				objet_incident: "Objet de l'incident" ,
			date_signalement: 	"Date de signalement", 
			date_intervention: 	"Date d'intervention",
						salle: 	"Salle", 
					technicien: "Technicien", 
					demandeur: 	"Demandeur",
				niveau_urgence: "Niveau d'urgence", 
			niveau_complexite:	"Niveau de complexité"
		})
		layout.addWidget @incident_list, 1, Qt::AlignTop
		@list_width = @incident_list.width
	end

	def add_incident_panel
		@panel_width = 400
		@incident_panel.setFixedSize @panel_width, @incident_panel.height
		@incident_panel.move geometry.x + @list_width + 20, geometry.y
		add_panel_parts unless @selected_incident.blank?
	end

	def add_panel_parts
		@incident_panel_layout = Qt::VBoxLayout.new @incident_panel
		@incident_panel_layout.set_contents_margins 20, 0, 20, 20
		add_incident_info
		add_button_group
	end

	def add_incident_info
		fields = {
			id: "Id", 
			etat: "Etat", 
			materiel: "Materiel", 
			objet_incident: "Objet de l'incident" ,
			description_incident: "Description de l'incident",
			solution_incident: "Solution de l'incident",
			date_signalement: "Date de signalement", 
			date_intervention: "Date d'intervention",
			salle: "Salle", 
			technicien: "Technicien", 
			demandeur: "Demandeur",
			niveau_urgence: "Niveau d'urgence", 
			niveau_complexite: "Niveau de complexité"
			}
		@incident_display = Widget::IncidentTable.new @selected_incident, fields
		@incident_panel_layout.addWidget @incident_display, 1
	end

	def add_button_group
		incident_actions = Qt::Widget.new
		incident_actions.set_fixed_size 350, 50
		@actions_layout = Qt::HBoxLayout.new incident_actions
		@actions_layout.set_contents_margins 10, 0, 0, 20
		@incident_panel_layout.addWidget incident_actions, 1
		add_edit_button
		add_delete_button
	end

	def add_edit_button
		edit_button = Qt::PushButton.new "modifier"
		edit_button.connect SIGNAL :clicked do display_edit_page end
		@actions_layout.addWidget edit_button
	end

	def add_delete_button
		delete_button = Qt::PushButton.new "supprimer"
		delete_button.connect SIGNAL :clicked do confirm_delete end
		@actions_layout.addWidget delete_button
	end

	def display_window
		resize @incident_list.width, [@incident_list.height, 500].max
        setWindowTitle "GSB : Gérer incident"
        show
	end

	def display_edit_page
		IncidentController.new.update @selected_incident
		self.close
	end

	def confirm_delete
		popup = Qt::MessageBox.new self
		popup.window_title = 'GSB'; popup.icon = Qt::MessageBox::Critical
		popup.text = "Voulez-vous vraiment supprimer cet incident?"
		popup.standardButtons  = Qt::MessageBox::Ok | Qt::MessageBox::Cancel
		delete_incident if popup.exec == Qt::MessageBox::Ok
	end

	def delete_incident
		previous_incident = Utilisateur.where("id < ?", @selected_incident.id).last
		ActiveRecord::Base.connection.update "SET FOREIGN_KEY_CHECKS = 0"
		@selected_incident.destroy
		if @selected_incident.destroyed?
			refresh_ui
		end
		ActiveRecord::Base.connection.update "SET FOREIGN_KEY_CHECKS = 1"
	end
	
	def refresh_ui
		@incident_list.remove_row @incident_list.current_row
		if @incident_list.row_count > 0
			@incident_list.select_incident(@incident_list.current_row)
		else
			@incident_panel.hide
			setFixedSize @incident_list.width + 20, @incident_list.height + 20
		end
	end

	def closeEvent(event)
	    @incident_panel.close
  	end

  	def moveEvent(event)
	    @incident_panel.move event.pos.x + width, event.pos.y
  	end
end