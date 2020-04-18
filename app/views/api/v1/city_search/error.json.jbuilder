json.error do
  json.status @error.status
  json.title @error.title
  json.detail @error.detail
end
