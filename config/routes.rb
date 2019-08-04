# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'timesheets#index', as: 'index'
  get '/timesheets', to: 'timesheets#index'
  get '/timesheets/new', to: 'timesheets#new', as: 'new_timesheet'
  get '/timesheets/:id', to: 'timesheets#show', as: 'timesheet'
  post '/timesheets', to: 'timesheets#create', as: 'create_timesheet'
  get '/timesheets/:id/edit', to: 'timesheets#edit', as: 'edit_timesheet'
  patch '/timesheets/:id', to: 'timesheets#udpate', as: 'update_timesheet'

  root to: 'timesheets#index'
end
