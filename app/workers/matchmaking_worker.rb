class MatchmakingWorker
  include SuckerPunch::Job
  def perform(id, ownerid)

    intrst = Interest.find(id)
    owner = User.find(ownerid)
    category = intrst.category
    subcategory = intrst.subcategory

    role = owner.roles.pluck(:name).to_s.titleize.gsub!('[', '(').gsub!(']', ')')
    owneridStr = owner.id.to_s
    idStr = intrst.id.to_s
    target = intrst.target.downcase
    tags = intrst.tags.pluck(:name).to_s.gsub!('[', '(').gsub!(']', ')')
    typus = intrst.typus
    find = ''
    if intrst.offer == 'offer'
      find = 'search'
    else
      find = 'offer'
    end
    p tags
    #Find only interests that are not this one or belong to us.
    selffilter = 'WHERE interests.id != '+idStr+' AND users.id != '+owneridStr
    #If we're offering, find searches and vice versa.
    offerfilter = ' AND interests.offer = "'+find+'"'
    #Find Interests where the typus matches.
    typusfilter = ' AND interests.typus = "'+typus+'"'
    # Check wether the target role is what we're looking for and our role is what they're looking for.
    targetfilter = ' AND interests.target IN '+role
    rolefilter = ' AND rolename = "'+target+'"'
    # Check wether keywords overlap
    keywordfilter = ' AND (interests.name IN '+tags+' OR interests.name IS NULL)'    
    # Check if the category matches or the target category is 'Beliebig'
    catfilter = ' AND (interests.category = "'+category+'" OR interests.category = "Beliebig") '
    # Check if the subcategory matches or the target subcategory is 'Beliebig'
    subcatfilter = ' AND (interests.subcategory = "'+subcategory+'" OR interests.subcategory = "Beliebig") '

    #If your own category or subcategory is 'Beliebig', you don't care about the other's category
    # or subcategory or keywords.
    if category == "Beliebig"
      catfilter = ' '
      keywordfilter = ' '
    end
    if subcategory == "Beliebig"
      subcatfilter = ' '
      keywordfilter = ' '
    end

    Mysql2::Client.default_query_options.merge!(symbolize_keys: :true, as: :hash)
    
    sql = 'SELECT interests.id, interests.title, interests.user_id, users.email, users.news, interests.name FROM (SELECT interests.*, tags.name, COUNT(tags.id) AS count FROM interests LEFT JOIN ('+
    'SELECT tags.id, tags.name, taggings.taggable_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.taggable_type="Interest"'+
    ' AND taggings.context = "tags") AS tags ON tags.taggable_id = interests.id GROUP BY interests.id, tags.name ORDER BY count) AS interests INNER JOIN (SELECT users.id,'+
    ' users.email, users.news, roles.name AS rolename FROM users INNER JOIN (SELECT roles.name, users_roles.user_id FROM roles INNER JOIN users_roles ON roles.id = users_roles.role_id)'+
    ' AS roles ON roles.user_id = users.id) AS users ON interests.user_id = users.id '+
    selffilter+offerfilter+typusfilter+targetfilter+rolefilter+keywordfilter+catfilter+subcatfilter
    #Original Line, in case stuff breaks.
    #'WHERE interests.id != '+idStr+' AND users.id != '+owneridStr+' AND rolename = "'+target+'" AND interests.offer = "'+find+'" AND interests.target IN '+role+' AND interests.name IN '+tags+' AND interests.category = "'+category+'" AND interests.subcategory = "'+subcategory+'"'  
    
    related = ActiveRecord::Base.connection.exec_query(sql, "Matchmaking", []).to_hash.uniq;
    unless related.empty?
      p related
      # Send fitting offers to Owner
      p "Sender:"
      p owner
      if owner.news
        MatchMailer.all_for_one_email(owner, related).deliver_later
      end
      # Send Owner's offer to fitting Users
      mails = []
      related.each do |intr|
        if intr['news']
          mails.push(intr['email'])
        end
      end
      p "Receivers:"
      p mails.uniq
      mails.uniq.each do |mail|
        MatchMailer.one_for_all_email(mail, intrst).deliver_later
      end
    else
      p 'Nothing found.'
    end
  end
end