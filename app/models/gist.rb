class Gist < ActiveRecord::Base
  has_many:fichiers
   
  def self.get_connection
    url = 'https://api.github.com'
    connection = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    connection
  end
  
  
  def self.authentification(connection,login,password)
    connection.basic_auth(login, password)
  end
  
  def self.get_public_gists()
    conn = get_connection
    conn.get('https://api.github.com/gists')
  end
  
  def get_gists_by_user(connection,username)   
    connection.get("https://api.github.com/users/#{username}/gists")
  end
  
  def get_users(connection)
    connection.get('https://api.github.com/users')
  end
  
  def get_gist_by_id(connection,gist_id)
    connection.get('https://api.github.com/gists/',gist_id)
  end
  
  def self.post_gist(connection,gist)
    connection.post('https://api.github.com/gists',gist.to_json)
  end
  
  def self.make_local_repository
    reponse_du_serveur =  get_public_gists()
    liste_gists = []
    if reponse_du_serveur.status == 200
      reponse_body = JSON.parse reponse_du_serveur.body
      reponse_body.each do |gt| 
        userlogin = "anonymous"
        if gt["owner"] != nil
          userlogin =gt["owner"]["login"]
        end 
        nouv_gist = Gist.find_or_initialize_by(hubid: gt["id"])
        nouv_gist.userlogin = userlogin
        nouv_gist.public = true
        liste_gists << nouv_gist
      end
    end
    liste_new_gist = liste_gists.select { |obj| obj.id.nil? } 
    ActiveRecord::Base.transaction {
      liste_new_gist.each { |g| g.saved = true; g.save
      }
    }
  end
  
  
  def get_user_identifiant(connection,response)
    identifiant = nil
    if response.status == 200
      identifiant =(JSON.parse response.body)["id"]
    end
    identifiant
  end
  
  def self.create_local_and_github_gists(login,password,gist_local,file_local) 
    reponce = nil
    conn = get_connection
    files_liste = []
    if(login != "" && password != "" )
      authentification(conn,login,password)
    end

    logger.info "  SSSSSS file_local =  #{file_local}"
    logger.info "  SSSSSS file_localclass =  #{file_local.class}"
     
    #    all_files = file_local
    #    all_files.collect {|fn| {fn[:filename] => {"content" => fn[:content]} }} 
    #    
    #    gist_github = {"public" => gist_local["public"], "description" => gist_local["description"], "files" => all_files  } 
    #    
    gist_github = {"public" => gist_local["public"], "description" => gist_local["description"], "files" => {file_local[:filename] => {"content" => file_local[:content]} }  } 
    
  
    logger.info "  SSSSSS gist_github =  #{gist_github}"
    
    reponse_du_serveur =  post_gist(conn,gist_github)
    logger.info "  SSSSSS status =  #{reponse_du_serveur.status}"
    if reponse_du_serveur.status == 201
      
    
      #  file = Fichier.new ;file.filename = file_local[:filename]; file.content = file_local[:content]; file.gist = gist_local ;files_liste << file}     
      #     file_local.each{|f,| file = Fichier.new ;file.filename = fn[:filename]; file.content = fn[:content]; file.gist = gist_local ;files_liste << file}     
      reponse_body = JSON.parse reponse_du_serveur.body
      
      logger.info " ***********************reponse_body[id].to_i=  #{reponse_body["id"]}"
      gist_local["hubid"] = reponse_body["id"]
      userlogin = "anonymous"
      if reponse_body["owner"] != nil
        userlogin =reponse_body["owner"]["login"]
      end 
    
      gist_local.userlogin = userlogin       
      gist_local["saved"] = true
      gist_local.save
      if file_local != nil && file_local.size != 0
        file = Fichier.new 
        file.filename = file_local[:filename]
        file.content = file_local[:content]
        file.gist = gist_local 
        file.save
      end
      reponce = 201
    end 
    if reponse_du_serveur.status == 401
      reponce = 401
      raise "Erreur de login :-( #{reponse_du_serveur.status}"
    end
    reponce
  end
end
