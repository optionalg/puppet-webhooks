require 'spec_helper'
require 'puppet_labs/github/issue'

describe 'PuppetLabs::Github::Issue' do
  subject { PuppetLabs::Github::Issue.new }
  let(:payload) { read_fixture("example_issue.json") }
  let(:data)    { JSON.load(payload) }

  it 'creates a new instance using the from_json class method' do
    pr = PuppetLabs::Github::Issue.from_json(payload)
  end

  it 'initializes with json' do
    pr = PuppetLabs::Github::Issue.new(:json => payload)
    pr.action.should == "opened"
  end

  describe '#load_json' do
    it 'loads a json hash readable through the data method' do
      subject.load_json(payload)
      subject.action.should == "opened"
    end
  end

  describe "#action" do
    actions = [ "opened", "closed", "reopened" ]
    payloads = [
      read_fixture("example_issue.json"),
      read_fixture("example_issue_closed.json"),
      read_fixture("example_issue_reopened.json"),
    ]

    actions.zip(payloads).each do |action, payload|
      it "returns '#{action}' when the issue is #{action}." do
        subject.load_json(payload)
        subject.action.should == action
      end
    end
  end

  describe '#pull_request' do
    subject { PuppetLabs::Github::Issue.new(:json => payload) }

    it "is an instance of PuppetLabs::Github::PullRequest" do
      expect(subject.pull_request).to be_a_kind_of PuppetLabs::Github::PullRequest
    end
  end

  context 'newly created issue' do
    subject { PuppetLabs::Github::Issue.new(:json => payload) }

    it 'has a number' do
      subject.number.should == data['issue']['number']
    end
    it 'has a repo name' do
      subject.repo_name.should == data['repository']['name']
    end
    it 'has a title' do
      subject.title.should == data['issue']['title']
    end
    it 'has a html_url' do
      subject.html_url.should == data['issue']['html_url']
    end
    it 'has a body' do
      subject.body.should == data['issue']['body']
    end
    it 'has a full name' do
      subject.full_name.should == data['repository']['full_name']
    end
  end
end
