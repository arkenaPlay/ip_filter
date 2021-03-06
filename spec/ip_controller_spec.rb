require 'spec_helper'
require 'dummy'

describe IpController do
  context "ip_validate" do
    before(:each) do
      IpFilter::Configuration.ip_whitelist = Proc.new { ["127.0.0.1/24"] }

    end

    it "should validate IP and raise error" do
      lambda{
        action_call(IpController, :test_action, :ip => '146.243.3.83')
      }.should raise_error(Exception, /GeoIP/)
    end

    it "should validate IP 127.0.0.1 and success" do
      lambda{
        action_call(IpController, :test_action, :ip => '127.0.0.1')
      }.should_not raise_error(Exception)
    end

    it "should validate IP 127.0.0.254 and success" do
      lambda{
        action_call(IpController, :test_action, :ip => '127.0.0.254')
      }.should_not raise_error(Exception)
    end

    it "should validate X Forwarded IP 127.0.0.254 and success" do
      lambda{
        action_call(IpController, :test_action, :ip => '146.243.3.83', :x_forward => "127.0.0.254")
      }.should_not raise_error(Exception)
    end

    it "should validate X Forwareded IP 146.243.3.83 and raise error" do
      lambda{
        action_call(IpController, :test_action, :ip => '127.0.0.254', :x_forward => '146.243.3.83')
      }.should raise_error(Exception, /GeoIP/)
    end

    it "should validate X Forwarded IP 127.0.0.254 and success" do
      lambda{
        action_call(IpController, :test_action, :ip => '146.243.3.83', :x_forward => "127.0.0.254, 146.243.3.83")
      }.should_not raise_error(Exception)
    end

    it "should validate X Forwareded IP 146.243.3.83 and raise error" do
      lambda{
        action_call(IpController, :test_action, :ip => '127.0.0.254', :x_forward => '146.243.3.83, 127.0.0.254')
      }.should raise_error(Exception, /GeoIP/)
    end


  end
  context "skip_ip_validate" do
    before(:each) do
      IpFilter::Configuration.ip_whitelist = Proc.new { ["127.0.0.1/24"] }

    end

    it "should validate IP and raise error" do
      lambda{
        action_call(IpController, :test_action_skip, :ip => '146.243.3.83')
      }.should_not raise_error
    end



  end

end