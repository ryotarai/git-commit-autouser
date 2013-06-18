require 'spec_helper'

module GitCommitAutouser
  describe Git do
    describe '.remote?' do
      subject { in_repo { described_class.remote?(name) } }
      context 'the existing remote name is passed' do
        let(:name) { "origin" }
        it { should be_true }
      end
      context 'the non-existing remote name is passed' do
        let(:name) { "invalid" }
        it { should be_false }
      end
    end

    describe '.remote_push_url' do
      subject { in_repo { described_class.remote_push_url(name) } }
      context 'the existing remote name is passed' do
        let(:name) { "origin" }
        it { should == 'origin-url' }
      end
      context 'the non-existing remote name is passed' do
        let(:name) { "invalid" }
        it { should == 'invalid' }
      end
    end

    describe '.rewrite_committer_author' do
      context 'when the repo has 1 commit' do
        subject do
          in_repo do |path|
            `git commit --allow-empty -m 'Hello'`
            described_class.rewrite_committer_author(name, email)
            `git log | cat`
          end
        end
        let(:name) { "John Lennon" }
        let(:email) { "john.lennon@gmail.com" }
        it { should include name }
        it { should include email }
      end
      context 'when the repo has 1 commit' do
        subject do
          in_repo do |path|
            `git commit --allow-empty -m 'Hello1'`
            `git commit --allow-empty -m 'Hello2'`
            described_class.rewrite_committer_author(name, email)
            `git log | cat`
          end
        end
        let(:name) { "John Lennon" }
        let(:email) { "john.lennon@gmail.com" }
        it { should include name }
        it { should include email }
      end
    end
  end
end
