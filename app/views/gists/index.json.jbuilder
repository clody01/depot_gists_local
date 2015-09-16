json.array!(@gists) do |gist|
  json.extract! gist, :id, :hubid, :description, :public, :userlogin, :saved
  json.url gist_url(gist, format: :json)
end
