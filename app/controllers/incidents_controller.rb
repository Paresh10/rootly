class IncidentsController < ApplicationController
	skip_before_action :verify_authenticity_token
	require "net/http"
	require "uri"
	require 'json'

	def index
		@incidents = Incident.all

	end

	def new
		@incident = Incident.new
	@test =	{
		  "label": "Email Address",
		  "name": "email",
		  "type": "text",
		  "subtype": "email",
		  "placeholder": "you@example.com",
			blocks: [
	      {
	        "type": "input",
	        "block_id": "note01",
	        "label": {
	          "type": "plain_text",
	          "text": "Note"
	        },
	        "element": {
	          "action_id": "content",
	          "type": "plain_text_input",
	          "placeholder": {
	            "type": "plain_text",
	            "text": "Take a note... "
	          },
	          "multiline": true
	        }
	      },
			]
		}

	@args = {
	    trigger_id: params[:trigger_id],
	    dialog: @test.to_json
	  }
		uri = URI("https://slack.com/api/dialog.open")
		res = Net::HTTP::Post.new(uri, @args)

		puts res.body
	end


# I, [2021-07-06T23:39:59.777239 #67]  INFO -- : [0a0f49ee-d40f-462d-bbc6-2ec1f94ea4ed]   Parameters: {"token"=>"[FILTERED]", "team_id"=>"T026RA9B7T4", "team_domain"=>"coding-kgn2878", "channel_id"=>"C026JHPRZV4", "channel_name"=>"random", "user_id"=>"U027407427K", "user_name"=>"paresh.sharma10", "command"=>"/rootly", "text"=>"", "api_app_id"=>"A026RAHCCRY", "is_enterprise_install"=>"false", "response_url"=>"https://hooks.slack.com/commands/T026RA9B7T4/2247361553331/7dNNVEKD0ZvgiZMSGt7HdQt5", "trigger_id"=>"2259814876305.2229349381922.dfe82b937e9bab84247fc2ab0e957049"}







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
