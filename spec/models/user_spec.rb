require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:customer_user)).to be_valid
  end

  let(:admin) { build(:admin_user) }
  let(:customer_user) { create(:customer_user) }


  describe 'validations' do
    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should allow_value(admin.email).for(:email) }
    it { should_not allow_value("demo@example").for(:email) }

  end

  describe 'associations' do
    it { should have_many(:rides) }
  end

  context "callbacks" do
    let(:user) { create(:customer_user) }
    it { callback(:set_default_role).after(:initialize) }
  end

  describe "public instance methods" do
    let(:customer_user) { create(:customer_user) }
    context "responds to its methods" do
      it { should respond_to(:active_rides) }
    end

    context "executes methods correctly" do

      context '#active_rides' do
        let(:new_user) { create(:customer_user) }
        it 'does user active_rides' do
          create(:cab)
          new_user.rides.create(source_latitude: 1, source_longitude: 2, destination_latitude: 3, destination_longitude: 4)
          expect(new_user.rides.count).to eq(1)
        end
      end

    end

  end
end
