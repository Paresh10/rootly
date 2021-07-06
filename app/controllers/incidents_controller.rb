class IncidentsController < ApplicationController

	def index
		@incidents = Incident.all

	end

	def new
		@incident = Incident.new

		data = params
		puts params
		render "new"
	end

	def create
		Incident.create!(
			title: params[:incident][:title],
			description: params[:incident][:description],
			severity: params[:severity],
			created_at: DateTime.now
		)

		redirect_to '/'
	end
end
