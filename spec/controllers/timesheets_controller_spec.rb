require 'rails_helper'

RSpec.describe TimesheetsController, type: :controller do
  before do
    Timesheet.destroy_all
  end

  let(:test_timesheet) do
    create(:timesheet)
  end

  let(:mocks) do
    attributes_for(:timesheet)
  end

  describe 'Routes' do
    describe '#GET: timesheets#index' do
      it 'returns status 200', filter: true do
        get :index
        expect(response.status).to eq(200)
      end

      it 'renders the index template', filter: true do
        get :index
        assert_template 'timesheets/index'
      end
    end

    describe '#GET: timesheets#new' do
      it 'returns status 200', filter: true do
        get :new
        expect(response.status).to eq(200)
      end

      it 'renders the new timesheet template', filter: true do
        get :new
        assert_template 'timesheets/new'
      end
    end

    describe '#POST: timesheets#create' do
      let(:valid_params) do 
        { date: mocks[:date],
          start_time: mocks[:start_time],
          end_time: mocks[:end_time] }
      end

      let(:form_for_params) do
        { 'timesheet': {
          'date(1i)': '2019',
          'date(2i)': '7',
          'date(3i)': '1',
          'start_time(4i)': '7',
          'start_time(5i)': '0',
          'end_time(4i)': '19',
          'end_time(5i)': '0'
        } }
      end

      it 'creates a Timesheet', filter: true do
        expect do
          post :create, params: valid_params
        end.to change(Timesheet, :count).by(1)
      end

      it 'creates a Timesheet when submitted from form_for', filter: true do
        expect do
          post :create, params: form_for_params
        end.to change(Timesheet, :count).by(1)
      end

      it 'assigns a new Timesheet', filter: true do
        post :create, params: valid_params
        assigns(:timesheet).should be_a(Timesheet)
      end
    end
  end
end
