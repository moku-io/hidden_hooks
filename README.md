# Hidden Hooks

A way to defer hooks to reduce dependencies.

Sometimes we need callbacks that break architectural dependencies. This gem allows to invert those dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hidden_hooks', '~> 1.0'
```

And then execute:

```bash
$ bundle
```

Or you can install the gem on its own:

```bash
gem install hidden_hooks
```

## Usage

### Raison d'être

Let's say we have a `User` model. Let's then say we integrate our app with a third-party issue tracker, and we need to mirror a user's issues in our app, so we create a `IssueTracker::Issue` model. In Rails we could do something like this:

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_many :issues, 
           class_name: 'IssueTracker::Issue', 
           dependent: :destroy
end

# app/models/issue_tracker/issue.rb
module IssueTracker
  class Issue < ApplicationRecord
    belongs_to :user
  end
end
```

This is fine for a small application, but becomes worrisome when the application grows and we start to need to track dependencies. Very clearly, the `User` model, which is a core part of the business model, should not depend on a third-party integration, but if we remove the association outright we lose the `dependent: :destroy` and the callback that it comes with.

We could do something like this:

```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Nothing here
end

# app/models/issue_tracker/issue.rb
module IssueTracker
  class Issue < ApplicationRecord
    belongs_to :user
    User.has_many :issues,
                  class_name: 'IssueTracker::Issue', 
                  dependent: :destroy
  end
end
```

This is just hiding the association, but it's still there; we can still do something like `user.issues`. A slightly better solution is to forego the association, and only keep the callback:

```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Still nothing here
end

# app/models/issue_tracker/issue.rb
module IssueTracker
  class Issue < ApplicationRecord
    belongs_to :user
    User.before_destroy do
      Issue.where(user: self).find_each(&:destroy!)
    end
  end
end
```

This solves the dependency issue, but introduces a new one: looking at the `User` model, there's no trace of the callback, so for example we might assume that `user.destroy!` will never fail, just to be surprised by a completely unexpected `ActiveRecord::RecordNotDestroyed`.

What we need is a way for `User` to declare that it expects others to define callbacks, while remaining ignorant about what those callbacks do. This would be an application of the Dependency Inversion Principle: `User` defines an interface, and others use that interface without having to really touch `User`.

### `HiddenHooks`

Hidden Hooks provides a unified interface for this specific dependency inversion: in the example above, the models would be defined like this:

```ruby
# app/models/user.rb
class User < ApplicationRecord
  before_destroy do
    HiddenHooks[User].before_destroy self
  end
end

# app/models/issue_tracker/issue.rb
module IssueTracker
  class Issue < ApplicationRecord
    belongs_to :user
    HiddenHooks.hook_up do
      before_destroy User do |user|
        Issue.where(user: user).find_each(&:destroy!) 
      end
    end
  end
end
```

> [!NOTE]
> You can call the hook whatever you want. The only constraint is if you use the [Rails integration](#rails-callbacks), as you see below.

#### Interface Declaration

A class `C` declares the interface through `HiddenHooks[C]`. Calling a method on the returned proxy will call every hook that someone else defined, forwarding any argument. 

#### Hook Definition

Whenever you want to define a hook, you simply call `HiddenHooks.hook_up`. Inside the block, you can call any method and pass it a class and a block: the block will become a hook for that class.

#### Rails Callbacks

Thanks to the [callback objects](https://guides.rubyonrails.org/active_record_callbacks.html#callback-objects) system, in Rails you can simply pass the proxy to the callback methods:

```ruby
class User < ApplicationRecord
  before_destroy HiddenHooks[User]
  before_create HiddenHooks[User]
  ...
end
```

To implicitly set all hooks like this for a given model, you can include `HiddenHooks::ActiveRecord`. If you want this to work for all models, include it in your `ApplicationRecord`.

### Eager Loading

The hooks you set up in a file can only work if that file is loaded, of course. In a Rails application, by default the development environment is not eager loaded, so you will probably see only certain hooks. To make Hidden Hooks work properly, enable eager loading in the `config/environments/development.rb` configuration file.

###  Multithreading

Hidden Hooks doesn't do anything to protect against concurrency fumbles. Its `hook_up` method is meant to be used "during class definition", not inside "runtime logic", for as much as these terms can mean in Ruby. For example, using `hook_up` inside an instance method is a recipe for fast disaster.

## Version numbers

Hidden Hooks loosely follows [Semantic Versioning](https://semver.org/), with a hard guarantee that breaking changes to the public API will always coincide with an increase to the `MAJOR` number.

Version numbers are in three parts: `MAJOR.MINOR.PATCH`.

- Breaking changes to the public API increment the `MAJOR`. There may also be changes that would otherwise increase the `MINOR` or the `PATCH`.
- Additions, deprecations, and "big" non breaking changes to the public API increment the `MINOR`. There may also be changes that would otherwise increase the `PATCH`.
- Bug fixes and "small" non breaking changes to the public API increment the `PATCH`.

Notice that any feature deprecated by a minor release can be expected to be removed by the next major release.

## Changelog

Full list of changes in [CHANGELOG.md](CHANGELOG.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moku-io/hidden_hooks.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
