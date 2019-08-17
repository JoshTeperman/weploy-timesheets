# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'timesheets#index', as: 'index'
  get '/timesheets', to: 'timesheets#index'
  get '/timesheets/new', to: 'timesheets#new', as: 'new_timesheet'
  get '/timesheets/:id', to: 'timesheets#show', as: 'timesheet'
  post '/timesheets', to: 'timesheets#create', as: 'create_timesheet'
  get '/timesheets/:id/edit', to: 'timesheets#edit', as: 'edit_timesheet'
  put '/timesheets/:id', to: 'timesheets#update', as: 'update_timesheet'
  resources :timesheets

  root to: 'timesheets#index'
end
