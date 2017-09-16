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
    sql = 'SELECT interests.*, users.* FROM (SELECT interests.*, tags.name, COUNT(tags.id) AS count FROM interests INNER JOIN ('+
    'SELECT tags.id, tags.name, taggings.taggable_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.taggable_type="Interest"'+
    ' AND taggings.context = "tags") AS tags ON tags.taggable_id = interests.id GROUP BY interests.id, tags.name ORDER BY count) AS interests INNER JOIN (SELECT users.id,'+
    ' users.email, roles.name AS rolename FROM users INNER JOIN (SELECT roles.name, users_roles.user_id FROM roles INNER JOIN users_roles ON roles.id = users_roles.role_id)'+
    ' AS roles ON roles.user_id = users.id) AS users ON interests.user_id = users.id '+
    'WHERE interests.id != '+idStr+' AND users.id != '+owneridStr+' AND rolename = "'+target+'" AND interests.offer = "'+find+'" AND interests.target IN '+role+' AND interests.name IN '+tags+' AND interests.category = "'+category+'" AND interests.subcategory = "'+subcategory+'"'  
    related = ActiveRecord::Base.connection.execute(sql)

    if related.size > 0
      # Send fitting offers to Owner
      p owner.email+ ': '
      p related.to_a
      # Send Owner's offer to fitting Users
      related.each do |intr|
        partner = User.find(intr[1])
        p partner.email + ': '
        p intrst
      end
    else
      p 'Nothing found.'
    end
  end
end
