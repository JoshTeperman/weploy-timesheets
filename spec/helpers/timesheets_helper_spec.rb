require 'rails_helper'
require 'date'

# Specs in this file have access to a helper object that includes
# the TimesheetsHelper. For example:
#
# describe TimesheetsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TimesheetsHelper, type: :helper do
  it 'fetch_day method: ' do
    expect(fetch_day(Date.new)).to eq('Monday')
  end
end
