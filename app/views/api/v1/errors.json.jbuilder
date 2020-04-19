json.prettify! # if params[:pretty] == 'true'

json.errors @errors do |error|
  json.status     error.status
  json.identifier error.identifier
  json.detail     error.detail
end
