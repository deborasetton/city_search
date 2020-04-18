Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get 'suggestions' => 'city_search#suggestions'
    end
  end
end
