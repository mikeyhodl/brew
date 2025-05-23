# frozen_string_literal: true

require "cmd/shared_examples/args_parse"
require "dev-cmd/create"

RSpec.describe Homebrew::DevCmd::Create do
  let(:url) { "file://#{TEST_FIXTURE_DIR}/tarballs/testball-0.1.tbz" }
  let(:formula_file) { CoreTap.instance.new_formula_path("testball") }

  it_behaves_like "parseable arguments"

  it "creates a new Formula file for a given URL", :integration_test do
    brew "create", "--set-name=Testball", url, "HOMEBREW_EDITOR" => "/bin/cat"

    expect(formula_file).to exist
    expect(formula_file.read).to match(%Q(sha256 "#{TESTBALL_SHA256}"))
  end

  it "generates valid cask tokens" do
    t = Cask::Utils.token_from("A FooBar_Baz++!")
    expect(t).to eq("a-foobar-baz-plus-plus")
  end

  it "retains @ in cask tokens" do
    t = Cask::Utils.token_from("test@preview")
    expect(t).to eq("test@preview")
  end
end
