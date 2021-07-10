class IncidentsController < ApplicationController
	skip_before_action :verify_authenticity_token
	require "net/http"
	require "uri"
	require 'json'
	responders :flash, :http_cache
	require 'dotenv'
	Dotenv.load('./.env')

	def index
		@incidents = Incident.all

	end

	def new
		@incident = Incident.new
	end

	def rootly_declare_title

    trigger_id = params[:trigger_id]
	payload = 	{
		  "trigger_id": trigger_id,
			"token": ENV['API_KEY'],
		  "dialog": {
		    "callback_id": "ryde-46e2b0",
		    "title": "Create a new Incident",
		    "submit_label": "Create",
		    "notify_on_cancel": true,
		    "state": "Limo",
		    "elements": [
		        {
		            "type": "text",
		            "label": "Title",
		            "name": "title"
		        },
		        {
		            "type": "text",
		            "label": "Description",
		            "name": "description"
		        },
						{
						  "label": "Severity",
						  "type": "select",
						  "name": "severity",
						  "options": [
						    {
						      "label": "Sev0",
						      "value": "sev0"
						    },
						    {
						      "label": "Sev1",
						      "value": "sev1"
						    },
						    {
						      "label": "Sev2",
						      "value": "sev2"
						    }
						  ]
						}
		    ]
		  }
		}


		headers  = {
			"Content-Type" => "application/json; charset=utf-8",
			"Authorization" => "Bearer " + ENV['API_KEY']
		}

		uri = URI.parse("https://slack.com/api/dialog.open")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		res = http.post(uri, payload.to_json, headers)

		puts "res.body"
		puts res.body


		render "incidents/rootly_declare_title", :formats => [:js], :locals => {}

	end


def create_incident
		puts"params"
		puts params[:payload]

		Incident.create!(
			title: params[:payload].submission.title,
			description: params[:payload].submission.description,
			severity: params[:payload].submission.severity,
			created_at: Datetime.now
		)

		payload = 	{
			  "trigger_id": trigger_id,
				"token": ENV['API_KEY'],
			  "dialog": {
					"name": params[:payload].submission.title,
					"is_private": false,
					"team_id": params[:payload].team.id,
					"creator": params[:payload].user.name
				}
			}


		headers  = {
			"Content-Type" => "application/json; charset=utf-8",
			"Authorization" => "Bearer " + ENV['API_KEY']
		}

		uri = URI.parse("https://slack.com/api/conversations.create")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		res = http.post(uri, payload.to_json, headers)

		puts "res.body"
		puts res.body

		redirect_to '/'

end

	def create
		Incident.create!(
			title: params[:payload][:title],
			description: params[:payload][:description],
			severity: params[:payload][:severity],
			created_at: current_user.time_zone
		)

		# redirect_to '/'
	end
end
