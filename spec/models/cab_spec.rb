require 'rails_helper'

RSpec.describe Cab, type: :model do
  it 'has a valid factory' do
    expect(build(:cab)).to be_valid
  end

  let(:cab) { build(:cab) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:latitude).on(:update) }
    it { should validate_numericality_of(:longitude).on(:update) }
  end

  describe "public instance methods" do

    context "responds to its methods" do
      it { should respond_to(:update_current_location) }

      context "executes methods correctly" do

        context '#update_current_location' do
          let(:new_cab){create(:cab)}
          it 'does cab update current location' do
            expect(new_cab.update_current_location(1,2)).to eq(true)
          end
          it 'does not cab update current location without valid latitude' do
            new_cab.update_current_location(nil,2)
            expect(new_cab.errors.full_messages).to include('Latitude cant be blank')
          end
          it 'does not cab update current location without valid longitude' do
            new_cab.update_current_location(1,nil)
            expect(new_cab.errors.full_messages).to include('Longitude cant be blank')
          end
        end

      end
    end

  end

  describe "class methods" do

    context '#find_nearest_cab' do
      let(:create_cabs){
        Cab.create(name:'cab1',latitude: 1, longitude: 10, is_available: true)
        Cab.create(name:'cab2',latitude: 2, longitude: 3, is_available: true)
        Cab.create(name:'cab3',latitude: 4, longitude: 10,color:'pink', is_available: true)
      }
      it 'does allocate nearest cab' do
         create_cabs
         expect(Cab.find_nearest_cab(1,2,nil).name).to eq('cab2')
      end

      it 'does allocate nearest pink cab' do
        create_cabs
        expect(Cab.find_nearest_cab(1,2,'pink').name).to eq('cab3')
      end

      it 'does not allocate cab without latitude' do
        create_cabs
        expect(Cab.find_nearest_cab(1,nil,nil)).to eq(nil)
      end

      it 'does not allocate cab without longitude' do
        create_cabs
        expect(Cab.find_nearest_cab(nil,1,nil)).to eq(nil)
      end

      it 'does not allocate cab without longitude and latitude' do
        create_cabs
        expect(Cab.find_nearest_cab(nil,nil,nil)).to eq(nil)
      end

      it 'does not allocate cab if no cabs found' do
        expect(Cab.find_nearest_cab(1,2,nil)).to eq(nil)
      end

    end
  end

end
