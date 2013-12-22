module GitCommitAutouser
  class Git
    def self.remote?(name)
      !!`git remote`.match(/^#{name}$/)
    end

    def self.remote_push_url(name)
      `git remote show -n #{name}`.match(/Push  URL: (.+)/)[1]
    end
  end
end

