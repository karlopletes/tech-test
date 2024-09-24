# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/absences', to: 'absences#index'
      post '/absences/update', to: 'absences#update'
    end
  end
end
