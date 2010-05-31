RailsApi::Application.routes.draw do |map|
  match "/modules/*name" => "main#index", :as => :method
  root :to => "main#index"
end
