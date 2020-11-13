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
      describe 'sets correct category for LS2 prefixes' do
        before(:each) do
          Cafe.create!({name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 2)})
          Cafe.create!({name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 2)})
          Cafe.create!({name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 2)})
          @ls2_cafe_small = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 1)}
          @ls2_cafe_large = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 3)}
        end
        it 'sets small category' do
          cafe = Cafe.create!(@ls2_cafe_small)
          expect(cafe.category).to eq("ls2 small")
        end
        it 'sets large category' do
          cafe = Cafe.create!(@ls2_cafe_large)
          expect(cafe.category).to eq("ls2 large")
        end
      end
      describe 'sets correct category for other prefixes' do
        before(:each) do
          @lso_cafe_one = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS7 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 1)}
          @lso_cafe_two = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS8 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 2)}
        end
        it 'sets small category' do
          cafe = Cafe.create!(@lso_cafe_one)
          expect(cafe.category).to eq("other")
        end
        it 'sets medium category' do
          cafe = Cafe.create!(@lso_cafe_two)
          expect(cafe.category).to eq("other")
        end
      end
      describe 'sets correct category on updates' do
        before(:each) do
          @ls1_cafe = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS1 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 1)}
          Cafe.create!({name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 2)})
          Cafe.create!({name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 2)})
          Cafe.create!({name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 2)})
          @ls2_cafe = {name: Faker::Restaurant.name,
            address: Faker::Address.street_address,
            post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
            chairs: Faker::Number.number(digits: 1)}
        end
        it 'updates LS1 categories' do
          cafe = Cafe.create!(@ls1_cafe)
          expect(cafe.category).to eq("ls1 small")

          @ls1_cafe[:chairs] = Faker::Number.number(digits: 3)
          cafe.update!(@ls1_cafe)
          expect(cafe.category).to eq("ls1 large")
        end
        it 'updates LS2 categories' do
          cafe = Cafe.create!(@ls2_cafe)
          expect(cafe.category).to eq("ls2 small")

          @ls2_cafe[:chairs] = Faker::Number.number(digits: 4)
          cafe.update!(@ls2_cafe)
          expect(cafe.category).to eq("ls2 large")
        end
        it 'updates other categories' do
          cafe = Cafe.create!(@ls2_cafe)
          expect(cafe.category).to eq("ls2 small")

          @ls2_cafe[:post_code] = "LS8 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}"
          cafe.update!(@ls2_cafe)
          expect(cafe.category).to eq("other")

          @ls2_cafe[:post_code] = "LS1 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}"
          cafe.update!(@ls2_cafe)
          expect(cafe.category).to eq("ls1 small")
        end
      end
    end
  end
end
