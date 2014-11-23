module GitCommitAutouser
  class Cli
    def self.start(argv=ARGV)
      unless Git.remote?("origin")
        $stderr.puts "[warn] remote `origin` is not configured"
      end

      remote_url = Git.remote_push_url("origin")

      users = Config.users
      if users.empty?
        $stderr.puts <<-EOS
No user setting found. You should add to ~/.gitconfig like the following.
------
[#{Config::USER_CONFIG_PREFIX}github]
  url-regexp = github.com
  name = "Foo Bar"
  email = foo@private.com
[#{Config::USER_CONFIG_PREFIX}ghe]
  url-regexp = git.company.com
  name = "Foo Bar"
  email = bar@company.com
------
        EOS
        abort
      end

      matched = nil
      users.each do |user|
        matched = user.url_regexp.match(remote_url)
        unless matched.nil?
          matched = user
          break
        end
      end

      if matched
        env = {
          "GIT_COMMITTER_NAME" => matched.name,
          "GIT_COMMITTER_EMAIL" => matched.email,
          "GIT_AUTHOR_NAME" => matched.name,
          "GIT_AUTHOR_EMAIL" => matched.email,
          "HUB_CONFIG" => matched.hub_config,
        }
      else
        env = {}
        $stderr.puts "[warn] No user setting matched. Abort."
        $stderr.puts "[warn] Remote Url: #{remote_url}"
      end

      system env, "git", "commit", *argv
      exit $?.exitstatus
    end
  end
end
