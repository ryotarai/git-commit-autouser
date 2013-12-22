# git-commit-autouser [![Build Status](https://travis-ci.org/ryotarai/git-commit-autouser.png?branch=master)](https://travis-ci.org/ryotarai/git-commit-autouser)

git-commit-autouser sets name and email of committer and author automatically. The name and email are determined by the url of the remote origin.

## Installation

```
$ gem install git-commit-autouser
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
$ git ci
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
