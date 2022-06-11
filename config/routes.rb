Rails.application.routes.draw do
  resources :products
  post "/import" => "products#import"
end
