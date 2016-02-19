class Repo < ActiveRecord::Base

  belongs_to :user
  has_one :board
  has_many :issues
  include AppModules::Http

  def self.findOrCreateRepos(user, result)
    result.each do |repo|
      self.find_by(github_id: repo['id']) || self.createRepo(repo, user.id)
    end
  end

  def self.createRepo(repo, user_id)
    create! do |r|
      r.name = repo['name']
      r.full_name = repo['full_name']
      r.syn = false
      r.github_id = repo['id']
      r.user_id = user_id
    end
  end


  def createWebhook(token)
    path = "repos/#{self.full_name}/hooks"
    data =  {
        'name': 'web',
        'active': true,
        'events': [
            'issues',
            'issue_comment',
            'pull_request'
        ],
        'config': {
            'url': "#{ENV['WEB_URL']}/github/#{self.github_id}/hooks",
            "content_type": "json"
        }
    }
    res = sendGithubPostRequest(path, token, data)
    if res.status == 201
      self.update(syn: true)
    else
      # TODO: make error page show to user
      puts 'error: can not create webhook'
    end
  end

  def createIssue(name, issue_id)
    issue = self.issues.create(name: name, github_id: issue_id)
    issue.card = card
  end

  def handleWebhhok(json)
    action = json['action']
    issue = json['issue']
    issue_id = issue['id']
    title = issue['title']
    body = issue['body']
    repo_id = json['repository']['id']
    repo = Repo.find_by(github_id: repo_id)
    case action
      when 'opened'
        list = self.board.lists.find_by_category('openIssue')
        data = [ ['name', title], ['desc', body], ['idList', list.trello_id], ['urlSource', 'null'], ['due', 'null']]
        card = list.createCard(data, title)
        repo.createIssue(title, issue_id, card)
        puts 'create new issue card successfully'
      when 'closed'
        card = Issue.find_by_github_id(issue_id).card
        list = self.board.lists.find_by_category('closeIssue')
        data = [['value', list.trello_id]]
        list.moveCard(card, list, data)
        puts 'move closed issue card successfully'
      when 'created'
        issue = Issue.find_by_github_id(issue_id)
        card = issue.card
        list = card.list
        comment_body = URI.encode(json['comment']['body'])
        data = [['text', comment_body]]
        list.createComment(card, data)
        puts 'create new comment on card successfully'
      else
        puts 'Function not supported yet......, now only support open new issue, close new issue, and creat new comment'
    end
  end

end
