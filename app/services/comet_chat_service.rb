class CometChatService

  # Allows HTTP communication
  include HTTParty
  # URI for API calls
  BASE_URI = 'https://api-us.cometchat.io/v2.0'.freeze

  # function: initialize(params)
  # purpose: Sets global variable @params from input
  def initialize(params)
    @params = params
  end

  # function: create_user
  # purpose: This function takes the Lookit user's user id and first name and creates them
  # as a user in CometChat. User Id is unique in CometChat and in Lookit, so it works well enough.
  def create_user
    # Set the body of the message
    body = {
      uid: params[:username],
      name: params[:firstname]
    }
    # Create and post message to CometChat
    response = HTTParty.post("#{BASE_URI}/users", headers: headers, body: body)
    response.dig('data')
  end

  private

  attr_accessor :params

  # function: headers
  # purpose: This function sets the headers for posting messages to CometChat.
  def headers
    {
      apikey: ENV['COMETCHAT_API_KEY'],
      appid: ENV['COMETCHAT_APP_ID']
    }
  end
end
