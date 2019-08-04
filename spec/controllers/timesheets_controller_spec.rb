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
      it 'returns status 200', :filter => true do
        get :index
        expect(response.status).to eq(200)
      end

      it 'renders the index template', :filter => true do
        get :index
        assert_template 'timesheets/index'
      end
    end

    describe '#GET: timesheets#new' do
      it 'returns status 200', :filter => true do
        get :new
        expect(response.status).to eq(200)
      end

      it 'renders the new timesheet template', :filter => true do
        get :new
        assert_template 'timesheets/new'
      end
    end

    describe '#POST: timesheets#create' do
      let(:valid_params) {{
        date: mocks[:date],
        start_time: mocks[:start_time],
        end_time: mocks[:end_time]
      }}

      it 'creates a Timesheet ', :filter => true do
        expect do
          post :create, params: valid_params
        end.to change(Timesheet, :count).by(1)
      end

      it 'assigns a new Timesheet', :filter => true do
        post :create, params: valid_params
        assigns(:timesheet).should be_a(Timesheet)
        # expect(response.status).to eq(302)
        # assert_template 'timesheets/index'
        # expect(response).to redirect_to('/timesheets/index')
      end

      # inside 'describe "#create"'

        # let(:valid_params) { {'post' => {'title' => 'Test Post'} }

        # it 'creates a new Post' do
        #   expect {
        #     post :create, valid_params
        #   }.to change(Post, :count).by(1)
        # end

        # and / or

        # it 'assigns a new Post' do
        #   post :create, valid_params
        #   assigns(:post).should be_a(Post)
        #   assigns(:post).should be_persisted
        # end
      it "renders :new when timesheet doesn't save"
      it "renders :index when timesheet saves"
    end
  end
end