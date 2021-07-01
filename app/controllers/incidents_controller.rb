class IncidentsController < ApplicationController

	def index
		Incident.all
	end

	def new
		@incident = Incident.new
	end
end
