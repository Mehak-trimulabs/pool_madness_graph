Pool Madness Graph
=======================

This is the GraphQL API for https://pool-madness.com. The project is used to manage a bracket pool in the NCAA March
Madness basketball tournament. Mostly though, this project is open-sourced to highlight and discuss different patterns
and practices of developing the GraphQL API.


Prerequisites
---------------

The following should be installed/running on your dev environment:

* Ruby (see .ruby-version for current)
* Bundler: `gem install bundler`
* PostgreSQL
* Redis

Also, you should have accounts and test keys for the following SaaS:

* Stripe (payment processing)
* Auth0 (user authentication)


Set .env Variables
--------------------

You should update the .env variables to be your own accounts for Stripe and Auth0. Also,
you should randomize your dev SECRET_KEY_BASE. Running `rails secret` will generate a new
key base that you can put in .env.


Setup and Start Server
----------------------

It's a typical Ruby/Rails app.

```bash
bundle install
rails db:create:all
rails db:reset
rails server
```

This will create some sample data as well. You can point your GraphQL client to
`http://localhost:3001/graphql` to get the schema and run queries.

GraphiQL Client
----------------

You can run any standard client you want and point it to the `http://localhost:3001/graphql`
endpoint. A good one on Mac is graphiql-app. If you have Homebrew just run `brew cask install graphiql`

Most of the data in the graph is private. You can add a HTTP Header with a proper JWT
token. For example:

```
Authorization: Bearer <YOUR JWT TOKEN>
```

You can generate one at Auth0 for a user on your account. You can also just login to the web
client and copy the JWT from localStorage in the browser dev tools.
