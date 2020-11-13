require 'rails_helper'

RSpec.describe Cafe, type: :model do
  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:address)}
    it {should validate_presence_of(:post_code)}
    it {should validate_presence_of(:chairs)}
  end

  describe 'model methods' do
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
      @ls2_cafe_small = {name: Faker::Restaurant.name,
        address: Faker::Address.street_address,
        post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
        chairs: Faker::Number.number(digits: 1)}
      @ls2_cafe_large = {name: Faker::Restaurant.name,
        address: Faker::Address.street_address,
        post_code: "LS2 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
        chairs: Faker::Number.number(digits: 3)}
      @ls2_cafe_large_alt = Cafe.create!({name: Faker::Restaurant.name,
        address: Faker::Address.street_address,
        post_code: "LS2 #{Faker::Number.number(digits: 2)}#{Faker::Alphanumeric.alpha(number: 2)}",
        chairs: Faker::Number.number(digits: 3)})
      @lso_cafe_one = {name: Faker::Restaurant.name,
        address: Faker::Address.street_address,
        post_code: "LS7 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
        chairs: Faker::Number.number(digits: 1)}
      @lso_cafe_two = {name: Faker::Restaurant.name,
        address: Faker::Address.street_address,
        post_code: "LS8 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}",
        chairs: Faker::Number.number(digits: 2)}
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
    end
    describe 'set_category' do
      describe 'sets correct category for LS1 prefixes' do
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
        it 'updates LS1 categories' do
          cafe = Cafe.create!(@ls1_cafe_small)
          expect(cafe.category).to eq("ls1 small")

          @ls1_cafe_small[:chairs] = Faker::Number.number(digits: 3)
          cafe.update!(@ls1_cafe_small)
          expect(cafe.category).to eq("ls1 large")
        end
        it 'updates LS2 categories' do
          cafe = Cafe.create!(@ls2_cafe_small)
          expect(cafe.category).to eq("ls2 small")

          @ls2_cafe_small[:chairs] = Faker::Number.number(digits: 4)
          cafe.update!(@ls2_cafe_small)
          expect(cafe.category).to eq("ls2 large")
        end
        it 'updates other categories' do
          cafe = Cafe.create!(@ls2_cafe_small)
          expect(cafe.category).to eq("ls2 small")

          @ls2_cafe_small[:post_code] = "LS8 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}"
          cafe.update!(@ls2_cafe_small)
          expect(cafe.category).to eq("other")

          @ls2_cafe_small[:post_code] = "LS1 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}"
          cafe.update!(@ls2_cafe_small)
          expect(cafe.category).to eq("ls1 small")
        end
      end
    end
    describe 'modify cafes' do
      it 'delete_small_cafes' do
        small_cafes = Cafe.where("cafes.category LIKE '%small'")
        small_count = small_cafes.size
        expect(Cafe.all.size).to eq(4)

        Cafe.delete_small_cafes

        small_cafes.reload
        expect(small_cafes).to eq([])
        expect(Cafe.all.size).to eq(4 - small_count)
      end
      it 'concatenate_med_large_cafes' do
        med_large_cafes = Cafe.where("cafes.category LIKE '%medium' OR cafes.category LIKE '%large'")

        expect(med_large_cafes[0].name).not_to include("large-")
        Cafe.concatenate_med_large_cafes
        med_large_cafes = Cafe.where("cafes.category LIKE '%medium' OR cafes.category LIKE '%large'")

        expect(med_large_cafes[0].name).to include("large-")
      end
    end
  end
end
