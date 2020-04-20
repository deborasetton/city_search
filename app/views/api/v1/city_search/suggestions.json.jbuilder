json.prettify! if params[:pretty] == 'true'

json.suggestions @suggestions do |search_match|
  json.name      search_match.display_name
  json.latitude  search_match.latitude
  json.longitude search_match.longitude
  json.score     search_match.score

  if params[:explain_score] == 'true'
    json.explain_score search_match.explain_score
  end
end
