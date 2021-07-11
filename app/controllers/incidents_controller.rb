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

		# data = {"payload"=>"{\"type\":\"dialog_submission\",\"token\":\"0UcG8yTyUwEmgDvQBvevPQQ1\",\"action_ts\":\"1626034400.480146\",\"team\":{\"id\":\"T026RA9B7T4\",\"domain\":\"coding-kgn2878\"},\"user\":{\"id\":\"U027407427K\",\"name\":\"paresh.sharma10\"},\"channel\":{\"id\":\"C026RA9BR8S\",\"name\":\"general\"},\"is_enterprise_install\":false,\"enterprise\":null,\"submission\":{\"title\":\"Hey\",\"description\":\"Hello\",\"severity\":\"sev0\"},\"callback_id\":\"ryde-46e2b0\",\"response_url\":\"https:\\/\\/hooks.slack.com\\/app\\/T026RA9B7T4\\/2259135896613\\/fMbsyMhae2jb69Y7lQ2Wo5lr\",\"state\":\"Limo\"}"}
		#
		#
		# puts "Payload"
		# # payload = eval data['payload']
		# # puts payload[:submission][:title]
		# json = JSON.parse(data['payload'])
		# puts json['submission']

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

		data = params
		params = JSON.parse(data['payload'])
		params['enterprise'] = ''
		puts"params"
		puts params


		Incident.create!(
			title: params['submission']['title'],
			description: params['submission']['description'],
			severity: params['submission']['severity'],
			created_at: DateTime.now
		)

		payload = 	{
				"token": ENV['API_KEY'],
			  "dialog": {
					"name": params['submission']['title'],
					"is_private": false,
					"team_id": params['team']['id'],
					"creator": params['user']['name'],
					"notify_on_close": true,
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

		redirect_to '/', :formats => [:js], :locals => {}

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
