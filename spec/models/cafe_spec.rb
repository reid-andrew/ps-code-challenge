require 'rails_helper'

RSpec.describe Cafe, type: :model do
  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:address)}
    it {should validate_presence_of(:post_code)}
    it {should validate_presence_of(:chairs)}
  end
end
