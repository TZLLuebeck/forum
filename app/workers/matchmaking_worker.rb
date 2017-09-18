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
    find = ''
    if intrst.offer == 'offer'
      find = 'search'
    else
      find = 'offer'
    end
    #sql = 'select roles.name, users_roles.user_id from roles inner join users_roles on roles.id = users_roles.role_id'
    
    #sql = 'select users.id, users.email, roles.name as rolename from users inner join (select roles.name, users_roles.user_id from roles inner join users_roles on roles.id = users_roles.role_id) as roles on roles.user_id = users.id'
     Mysql2::Client.default_query_options.merge!(symbolize_keys: :true, as: :hash)
    sql = 'SELECT interests.id, interests.title, interests.user_id, users.email FROM (SELECT interests.*, tags.name, COUNT(tags.id) AS count FROM interests INNER JOIN ('+
    'SELECT tags.id, tags.name, taggings.taggable_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.taggable_type="Interest"'+
    ' AND taggings.context = "tags") AS tags ON tags.taggable_id = interests.id GROUP BY interests.id, tags.name ORDER BY count) AS interests INNER JOIN (SELECT users.id,'+
    ' users.email, roles.name AS rolename FROM users INNER JOIN (SELECT roles.name, users_roles.user_id FROM roles INNER JOIN users_roles ON roles.id = users_roles.role_id)'+
    ' AS roles ON roles.user_id = users.id) AS users ON interests.user_id = users.id '+
    'WHERE interests.id != '+idStr+' AND users.id != '+owneridStr+' AND rolename = "'+target+'" AND interests.offer = "'+find+'" AND interests.target IN '+role+' AND interests.name IN '+tags+' AND interests.category = "'+category+'" AND interests.subcategory = "'+subcategory+'"'  
    #related = ActiveRecord::Base.connection.execute(sql)
    related = ActiveRecord::Base.connection.exec_query(sql, "Matchmaking", [ ]);
    filter = related.to_hash.uniq
    if filter.size
      # Send fitting offers to Owner      
      MatchMailer.all_for_one_email(owner, filter).deliver_later
      # Send Owner's offer to fitting Users
      mails = []
      filter.each do |intr|
        mails.push(intr['email'])
      end
      mails.uniq.each do |mail|
        MatchMailer.one_for_all_email(mail, intrst).deliver_later
      end
    else
      p 'Nothing found.'
    end
  end
end
