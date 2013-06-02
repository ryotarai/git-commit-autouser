module GitCommitAutouser
  class Config
    USER_CONFIG_PREFIX = "autouser-"
    User = Struct.new(:url_regexp, :name, :email)

    def self.users
      config = {}
      `git config --get-regexp "#{USER_CONFIG_PREFIX}.+\."`.split("\n").map do |c|
        c.split(" ", 2)
      end.each do |c|
        data = c.first.match(/#{USER_CONFIG_PREFIX}(.+)\.(.+)/)
        config[data[1]] ||= {}
        config[data[1]][data[2]] = c.last
      end

      config.values.map do |c|
        User.new.tap do |u|
          u.url_regexp = Regexp.new(c["url-regexp"])
          u.name = c["name"]
          u.email = c["email"]
        end
      end
    end
  end
end


