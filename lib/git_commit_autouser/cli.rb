module GitCommitAutouser
  class Cli
    def self.start(argv=ARGV)
      abort_no_origin! unless Git.remote?("origin")
      remote_url = Git.remote_push_url("origin")

      users = Config.users
      abort_no_user_config! if users.empty?

      matched = nil
      users.each do |user|
        matched = user.url_regexp.match(remote_url)
        unless matched.nil?
          matched = user
          break
        end
      end

      abort_no_user_matched! if matched.nil?

      env = {
        "GIT_COMMITTER_NAME" => matched.name,
        "GIT_COMMITTER_EMAIL" => matched.email,
        "GIT_AUTHOR_NAME" => matched.name,
        "GIT_AUTHOR_EMAIL" => matched.email,
      }

      env["HUB_CONFIG"] = matched.hub_config if matched.hub_config

      system env, "git", "commit", *argv
      exit $?.exitstatus
    end

    def self.abort_no_user_config!
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
      exit 1
    end

    def self.abort_no_origin!
      $stderr.puts "remote `origin` is not configured"
      exit 1
    end

    def self.abort_no_user_matched!
      $stderr.puts "No user setting matched. Abort."
      $stderr.puts "Remote Url: #{remote_url}"
      exit 1
    end
  end
end
