json.prettify! # if params[:pretty] == 'true'

json.errors @errors do |error|
  json.status error.status
  json.title  error.title
  json.detail error.detail
end
