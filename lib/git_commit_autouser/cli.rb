module GitCommitAutouser
  class Cli
    def self.start(argv=ARGV)
      remote = `git-remote show -n origin`
      remote_url = remote.match(/Push  URL: (.+)/)[1]

      config = {}
      `git-config --get-regexp "exuser-.+\."`.split("\n").map do |c|
        c.split(" ", 2)
      end.each do |c|
        data = c.first.match(/exuser-(.+)\.(.+)/)
        config[data[1]] ||= {}
        config[data[1]][data[2]] = c.last
      end

      if config.empty?
        $stderr.puts <<-EOS
No user setting found. You should add to ~/.gitconfig like the following.
------
[exuser-github]
    url-regexp = github.com
    name = "Foo Bar"
    email = foo@private.com
[exuser-ghe]
    url-regexp = git.company.com
    name = "Foo Bar"
    email = bar@company.com
------
        EOS
        exit 1
      end

      matched = nil
      config.each_pair do |name, c|
        matched = remote_url.match(c["url-regexp"])
        next if matched.nil?
        matched = c
        break
      end

      if matched.nil?
        $stderr.puts "No user setting matched. Abort."
        $stderr.puts "Remote Url: #{remote_url}"
        exit 1
      end

      system "git-commit", *argv

      unless $?.exitstatus == 0
        exit $?.exitstatus
      end

      system <<-EOS
git-filter-branch -f --commit-filter '
  GIT_COMMITTER_NAME="#{matched["name"]}";
  GIT_AUTHOR_NAME="#{matched["name"]}";
  GIT_COMMITTER_EMAIL="#{matched["email"]}";
  GIT_AUTHOR_EMAIL="#{matched["email"]}";
  git commit-tree "$@";
' HEAD~1..HEAD
      EOS

      exit $?.exitstatus
    end
  end
end
