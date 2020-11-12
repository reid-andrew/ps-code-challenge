require 'rails_helper'

RSpec.describe Cafe, type: :model do
  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:address)}
    it {should validate_presence_of(:post_code)}
    it {should validate_presence_of(:chairs)}
  end

  describe 'model methods' do
    describe 'set_category' do
      describe 'sets correct category for LS1 prefixes' do
        before(:each) do
          @ls1_cafe_small = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS1 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 1)}
          @ls1_cafe_medium = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS1 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 2)}
          @ls1_cafe_large = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS1 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 3)}
        end
        it 'sets small category' do
          cafe = Cafe.create!(@ls1_cafe_small)
          expect(cafe.category).to eq("ls1 small")
        end
        it 'sets medium category' do
          cafe = Cafe.create!(@ls1_cafe_medium)
          expect(cafe.category).to eq("ls1 medium")
        end
        it 'sets large category' do
          cafe = Cafe.create!(@ls1_cafe_large)
          expect(cafe.category).to eq("ls1 large")
        end
      end
    end
  end
end
