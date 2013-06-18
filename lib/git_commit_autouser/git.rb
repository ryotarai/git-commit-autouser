module GitCommitAutouser
  class Git
    def self.remote?(name)
      !!`git remote`.match(/^#{name}$/)
    end

    def self.remote_push_url(name)
      `git remote show -n #{name}`.match(/Push  URL: (.+)/)[1]
    end

    def self.rewrite_committer_author(name, email, rev=nil)
      if rev.nil?
        commit_count = `git rev-list HEAD --count`.to_i
        if commit_count == 1
          rev = "HEAD"
        else
          rev = "HEAD~1..HEAD"
        end
      end
      unless rev.nil?
        cmd = <<-EOS
  git filter-branch -f --commit-filter '
    GIT_COMMITTER_NAME="#{name}";
    GIT_AUTHOR_NAME="#{name}";
    GIT_COMMITTER_EMAIL="#{email}";
    GIT_AUTHOR_EMAIL="#{email}";
    git commit-tree "$@";
  ' #{rev}
        EOS
        `#{cmd}`
      end
    end
  end
end

