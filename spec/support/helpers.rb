require 'tmpdir'
require 'fileutils'

module Helpers
  def in_repo(&block)
    Dir.mktmpdir do |tmp|
      src = File.expand_path('../git-repo', File.dirname(__FILE__))
      FileUtils.copy_entry(src, tmp + '/.git')
      Dir.chdir(tmp, &block)
    end
  end
end

