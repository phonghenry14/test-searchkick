class UserSearch
  attr_reader :query, :options

  def initialize(query:nil, options: {})
    @query = query.presence || "*"
    @options = options
  end

  def search
    User.search(query, {page: options[:page], per_page: 20})
  end
end
