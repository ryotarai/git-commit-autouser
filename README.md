# Git::Commit::Autouser

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'git-commit-autouser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-commit-autouser

### rbenv, system ruby and specific_install

```
rbenv shell system
sudo gem install specific_install
sudo gem specific_install -l git@github.com:ryotarai/git-commit-autouser.git
rbenv rehash
```

## Usage

Add the following settings to .gitconfig:

```
[autouser-github]
    url-regexp = github.com
    name = "Ryota Arai"
    email = ryota.arai@gmail.com
[autouser-company]
    url-regexp = git.company.com
    name = "Ryota Arai"
    email = ryota.arai@company.com
[alias]
    ci = commit-autouser
```

Use `git ci` instead of `git commit`:

```
git ci
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
