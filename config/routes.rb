Rails.application.routes.draw do
  root to: redirect(ENV.fetch('API_DOCS_URL'))

  namespace 'api' do
    namespace 'v1' do
      get 'suggestions' => 'city_search#suggestions'
    end
  end
end
