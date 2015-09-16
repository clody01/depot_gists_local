json.array!(@fichiers) do |fichier|
  json.extract! fichier, :id, :filename, :content, :language
  json.url fichier_url(fichier, format: :json)
end
