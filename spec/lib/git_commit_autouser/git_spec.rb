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
  end
end
