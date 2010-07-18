require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Jsss" do
  it "should load sample specs" do
    JSON::Spec::Parser.new(%{[{String: Integer}, ...]}).parse
  end
  
  it "should match good data to spec" do
    spec = JSON::Spec::Parser.new("[{String: Integer}, ...]").parse
    data = JSON::Pure::Parser.new('[{"123": 12}, {"ala": 16}]').parse
    # s.match(data).should == true
  end
  
  describe 'simple Array of Strings' do
    before(:all) do
      @spec = JSON::Spec::Matcher.new("[String, ...]")
    end
    
    it 'should be fine with proper data' do
      [
        '["Ala", "ma", "kota"]',
        '["Ala"]',
        '[]'
      ].each do |json|
        @spec.match(json).should == true
      end
    end
    
    it "should fail on other data" do
      [
        '["ala", 12]',
        '[1]',
        '{"x":"y"}'
      ].each do |json|
        @spec.match(json).should == false
      end
    end
  end
  
  describe 'Hash of keys to Strings' do
    before(:all) do
      @spec = JSON::Spec::Matcher.new('{"Thing1": String, "Thing2": String}')
    end
    
    it "should be fine on proper data" do
      @spec.match('{"Thing1": "kot", "Thing2": "foo"}').should == true
    end
    
    it "should fail on other data" do
      @spec.match('{}').should == false
      @spec.match('{"Thing1": "kot"}').should == false
      @spec.match('{"Thing2": "foo"}').should == false
      @spec.match('{"Thingwe1": "kot", "Thing2": "foo"}').should == false
    end    
  end

  describe 'Hash of Strings to Strings' do
    before(:all) do
      @spec = JSON::Spec::Matcher.new("{String: String}")
    end
    
    it "should be fine on proper data" do
      @spec.match('{}').should == true
      @spec.match('{"Ala": "kot"}').should == true
    end
    
    it "should fail on other data" do
      @spec.match('{"Ala": 1}').should == false
    end    
  end
  
  describe 'Hash with values and symbols' do
    before(:all) do
      @spec = JSON::Spec::Matcher.new('{"X": "Y", "Thing1": String, String: String}')
    end
    
    it "should be fine on proper data" do
      [
        '{"X": "Y", "Thing1": "String", "String": "String"}',
        '{"X": "Y", "Thing1": "String"}',
        '{"X": "Y", "Thing1": "String", "String": "String", "ala": "Kota"}'
      ].each do |json|
        @spec.match(json).should == true
      end
    end
    
    it "should fail on other data" do
      [
        '{"X": "Y", "Thing1": 4, "String": "String"}',
        '{"X": "Z", "Thing1": "String"}',
        '{"X": "Y", "Thing1": "String", "String": "String", "ala": 10}'
      ].each do |json|
        @spec.match(json).should == false
      end
    end    
  end
  
  describe 'array of hashes' do
    before(:all) do
      @spec = JSON::Spec::Matcher.new('[{"X": String, "Y": Integer}, ...]')
    end
    
    it "should be fine on proper data" do
      @spec.match('[]').should == true
      @spec.match('[{"X": "Y", "Y": 10},{"X": "Z", "Y": 20}]').should == true
    end
    
    it "should fail on other data" do
      [
        '{"X": "Y", "Thing1": 4, "String": "String"}',
        '{"X": "Z", "Thing1": "String"}',
        '[{"X": "Y", "Thing1": "String", "String": "String", "ala": 10}]'
      ].each do |json|
        @spec.match(json).should == false
      end
    end    
  end
end
