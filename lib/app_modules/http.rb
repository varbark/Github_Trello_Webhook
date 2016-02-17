module AppModules
  module Http
    def sendTrelloGetRequest(path, token, query = nil)
      url = ENV['TRELLO_API_URL'] + "#{path}" + "?key=#{ENV['TRELLO_APP_ID']}&token=#{token}"
      HTTP.get(url)
    end

    def sendTrelloPostRequest(path, token, query = nil)
      url = ENV['TRELLO_API_URL'] + "#{path}" + "?key=#{ENV['TRELLO_APP_ID']}&token=#{token}"
      url << query if query
      HTTP.post(url)

    end

    def sendTrelloPutRequest(path, token, query = nil)
      url = ENV['TRELLO_API_URL'] + "#{path}" + "?key=#{ENV['TRELLO_APP_ID']}&token=#{token}"
      url << query if query
      HTTP.put(url)
    end

    def sendGithubGetRequest(path, token)
      url = ENV['GITHUB_API_URL'] + path
      HTTP.headers(:Authorization => "token #{token}").get(url)
    end

    def sendGithubPostRequest(path, token, data)
      url = ENV['GITHUB_API_URL'] + path
      HTTP.headers(:Authorization => "token #{token}").post(url, :json => data)
    end
  end
end
