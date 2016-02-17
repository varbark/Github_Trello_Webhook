module AppModules
  module Http
    def sendTrelloGetRequest(path, token, query = nil)
      url = ENV['TRELLO_API_URL'] + "#{path}" + "?key=#{ENV['TRELLO_APP_ID']}&token=#{token}"
      url << query if query
      JSON.parse(HTTP.get(url))
    end
  end
end
