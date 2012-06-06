require 'spec_helper'

describe Spree::OrdersController do

  let(:option_type)  { mock_model(Spree::OptionType, :name => 'Color', :presentation => 'Color') }
  let(:option_value) { mock_model(Spree::OptionValue, :name => 'Red', :presentation => 'Red', :option_type => option_type, :adder => 2.0) }
  let(:user) { stub_model(Spree::User) }
  let(:order) { mock_model(Spree::Order, :number => "R123", :reload => nil, :save! => true, :coupon_code => nil, :user => user, :token => 'asd123')}

  before do
    Spree::LineItem.any_instance.stub(:save => true)
    Spree::Order.stub(:new).and_return(order)
  end

  context "#populate" do

    before do
      @photo = stub_model(Spree::OptionValue, :adder => 0.4)
      @variant = mock_model(Spree::Variant, :price => 9.01)
      Spree::Variant.stub(:find).and_return @variant
    end

    it "should handle parameter for photo" do
      options_params = [option_value.id.to_s]

      Spree::Order.should_receive(:new).and_return order

      order.should_receive(:add_variant).with(@variant, 1, options_params)
      post :populate, {:variant_id => @variant.id, :option_values => options_params}
    end

    it "should handle regular request with no options" do
      Spree::Order.should_receive(:new).and_return order
      Spree::OptionValue.should_not_receive(:find)

      order.should_receive(:add_variant).with(@variant, 2)
      post :populate, {:variants => {@variant.id => 2}}
    end

  end


end
