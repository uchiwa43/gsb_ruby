class Widget::IncidentTable < Qt::TableWidget

	def initialize incident, fields
		super()
		headers = fields.values
		@attributes = fields.keys
		set_row_count  headers.count
		setFixedSize 360, height
		set_column_count 1
		horizontalHeader.setVisible false
		setVerticalHeaderLabels headers
		horizontalHeader.setResizeMode Qt::HeaderView::Stretch 
		setSelectionBehavior Qt::AbstractItemView::NoSelection
		populate incident
	end

	def populate incident
		@attributes.each_with_index do |row, index|
			value = incident.send(row).to_s
			item  = Qt::TableWidgetItem.new value
			item.setFlags(Qt::ItemIsEnabled )
			setItem(index, 0, item)
		end
	end
	
end