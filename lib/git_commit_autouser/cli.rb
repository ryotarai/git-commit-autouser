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

      system "git", "commit", *argv
      exit $?.exitstatus unless $?.exitstatus == 0

      Git.rewrite_committer_author(matched.name, matched.email)
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
