# OpenIDConnect Sample RP

Implement OpenID Connect Relying Party ("RP") using the `openid_connect` gem.
Upgraded to run over Rails 4 framework
Use OAuth refresh_token feature (one the access_token get expired, a refresh token is sent to
the OP to get a new access_token, this way the user dont need to log in again)

## How to Run This Example on Your Machine

There are no configuration file changes needed to run the RP.

To run this in development mode:

* Download (or fork or clone) this repo
* `bundle install` (see "Note" section below if you get "pg"-gem-related problems)
* `bundle exec rake db:create db:migrate db:seed` (you have SQLite installed, right?)
* `bundle exec rails server -p 3001`

Point your browser at http://localhost:3001

If you download and run [the sample OP server](https://github.com/marfersth/openid_connect_sample)
you can have this RP use that OP for authentication
(use the OP's address in the "Discover" field, e.g. `localhost:3000`).
The two servers on localhost must run on different ports.

## Centos OpenSSL Complications

Centos' default OpenSSL package does not include some Elliptic Curve algorithms for patent reasons.
Unfortunately, the gem dependency `json-jwt` calls on one of those excluded algorithms.

If you see `uninitialized constant OpenSSL::PKey::EC` when you try to run the server,
this is your problem. You need to rebuild OpenSSL to include those missing algorithms.

This problem is beyond the scope of this README, but
[this question on StackOverflow](http://stackoverflow.com/questions/32790297/uninitialized-constant-opensslpkeyec-from-ruby-on-centos/32790298#32790298)
may be of help.


## Copyright

Copyright (c) 2011 nov matake. See LICENSE for details.

