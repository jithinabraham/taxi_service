require 'rails_helper'

RSpec.describe Ride, type: :model do
  it 'has a valid factory' do
    expect(build(:ride)).to be_valid
  end

  let(:user) { create(:customer_user) }
  let(:ride) {
    new_ride=build(:ride)
    user.rides.create(new_ride.attributes)
  }

  describe 'validations' do

    it { should validate_presence_of(:source_latitude) }
    it { should validate_numericality_of(:source_latitude) }

    it { should validate_presence_of(:source_longitude) }
    it { should validate_numericality_of(:source_longitude) }

    it { should validate_presence_of(:destination_longitude) }
    it { should validate_numericality_of(:destination_longitude) }

    it { should validate_presence_of(:destination_latitude) }
    it { should validate_numericality_of(:destination_latitude) }

    context '#is_cab_requestable?' do
      let(:new_user) { create(:customer_user) }

      it 'does user can request cab' do
        create(:cab)
        new_ride=user.rides.new(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
        expect(new_ride.is_cab_requestable?).to eq(nil)
      end

      it 'does not request cab if already requested' do
        create(:cab)
        create(:cab)
        user.rides.create(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
        new_request=user.rides.new(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
        new_request.valid?
        expect(new_request.errors.full_messages).to include("User Cannot request more than one ride")
      end

    end

    context '#check_cab_availability' do
      it 'does user can request cab ' do
        create(:cab)
        new_ride=user.rides.new(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
        expect(new_ride.valid?).to eq(true)
      end

      it 'cannot request cab if no cabs available' do
        create(:cab)
        user.rides.create(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
        new_ride=user.rides.create(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
        new_ride.valid?
        expect(new_ride.errors.full_messages).to include('Cab No cabs found,Request canceled')
      end

    end

    context 'callbacks' do
      it { callback(:inactivate_cab_status).after(:create) }
      it { callback(:activate_cab_status).before(:destroy) }
    end

  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:cancel) }
      it { should respond_to(:complete) }
    end

    context 'executes methods correctly' do
      context '#cancel' do
        it 'does cancel request' do
          create(:cab)
          new_ride=user.rides.create(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
          expect(new_ride.cancel).to eq(true)
        end

        it 'does not cancel request on a completed ride' do
          create(:cab)
          new_ride=user.rides.create(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
          new_ride.complete
          expect(new_ride.cancel).to eq(nil)
        end
      end

      context '#complete' do

        it 'does complete a request' do
          create(:cab)
          new_ride=user.rides.create(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
          expect(new_ride.complete).to eq(true)
        end

        it 'does not complete a cancelled request' do
          create(:cab)
          new_ride=user.rides.create(source_latitude: 1, source_longitude: 1, destination_latitude: 2, destination_longitude: 2)
          new_ride.cancel
          expect(new_ride.complete).to eq(nil)
        end

      end

    end

    context 'updated values' do
      it 'does calculate exact distance' do
        create(:cab)
        new_ride=user.rides.create(source_latitude: 1.0, source_longitude: 9.0, destination_latitude: 6.0, destination_longitude: 3.0)
        new_ride.complete
        expect(new_ride.distance).to eq(744.37)
      end

      it 'does calculate exact amount' do
        create(:cab)
        new_ride=user.rides.create(source_latitude: 1.0, source_longitude: 9.0, destination_latitude: 6.0, destination_longitude: 3.0)
        new_ride.complete
        expect(new_ride.amount.round).to eq(1489)
      end

    end
  end


end
