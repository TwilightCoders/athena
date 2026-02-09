# frozen_string_literal: true

RSpec.describe Athena::OptionDefinition do
  describe "#boolean?" do
    it "is true when type is nil" do
      opt = Athena::OptionDefinition.new(:verbose)
      expect(opt.boolean?).to be true
    end

    it "is true when type is TrueClass" do
      opt = Athena::OptionDefinition.new(:verbose, TrueClass)
      expect(opt.boolean?).to be true
    end

    it "is false when type is String" do
      opt = Athena::OptionDefinition.new(:env, String)
      expect(opt.boolean?).to be false
    end
  end

  describe "#default_value" do
    it "returns false for booleans without explicit default" do
      opt = Athena::OptionDefinition.new(:verbose)
      expect(opt.default_value).to be false
    end

    it "returns the explicit default" do
      opt = Athena::OptionDefinition.new(:env, String, default: "production")
      expect(opt.default_value).to eq("production")
    end

    it "returns nil for non-boolean without default" do
      opt = Athena::OptionDefinition.new(:env, String)
      expect(opt.default_value).to be_nil
    end
  end

  describe "#attach" do
    it "registers the option with an OptionParser" do
      opt = Athena::OptionDefinition.new(:env, String, short: :e, description: "Environment")
      parser = OptionParser.new
      store = {}

      opt.attach(parser, store)
      parser.parse!(["--env", "staging"])

      expect(store[:env]).to eq("staging")
    end

    it "handles short flags" do
      opt = Athena::OptionDefinition.new(:env, String, short: :e)
      parser = OptionParser.new
      store = {}

      opt.attach(parser, store)
      parser.parse!(["-e", "prod"])

      expect(store[:env]).to eq("prod")
    end

    it "handles boolean flags" do
      opt = Athena::OptionDefinition.new(:verbose, short: :v)
      parser = OptionParser.new
      store = {}

      opt.attach(parser, store)
      parser.parse!(["--verbose"])

      expect(store[:verbose]).to be true
    end
  end
end
