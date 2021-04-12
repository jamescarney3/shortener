
# Shortener
It's a URL shortener; it shortens the URLs. Practical example demo project.

## Prerequisites
* Ruby 3.0.1
* Rails 6.1.3.1

## How to Run
I picked Rails as my framework for this because it comes with everything the project needs right out of the box - installation, running the server, and running the tests are just the canonic Rails workflow and commands

### Installation
Clone or unzip the repo and `cd` into its main directory
Install dependencies by running `bundle install`
Migrate database by running `rails db:migrate`

### Local Web Server
`rails s`

### Tests
`rails test`

## Development Notes
### Model Layer
- single model that corresponds to a table of matches between fully qualified URLs and slugs
- slugs can't collide, long urls can
- short url records also need a secret key attribute to check during deletion requests so that only clients with knowledge of the secret key can trigger a deletion

### Controller Layer
- two controllers, one for redirects and one for short url administration
- redirection controller processes slugs, matches them to records and redirects if valid
- short urls resource controller has typical CRUD pattern with only create and destroy methods

### View Layer
- there's not enough modeling or serialization going on in this demo application to justify a true view layer; Rails' built-in JSON parsing is sufficient for our single controller

### Hypothetical Auth Strategy
If we didn't want a client to have to remember all of its short urls' secret attributes in order to delete them, we could instead store user records and validate a client's ownership of the short url it intends to delete via foreign key. If we expected (or decided) that the client consuming this API was an application running in a browser, generic session auth would probably be sufficient.

### Hypothetical Auto-Expiration
The simpler approach would be to add an expiration field to the `short_urls` table and either set it on new records with user input (within constraints if necessary) or generate it with some default behavior (say, 30 days from `Date.today`). We'd then extend the top level controller's redirect method to look up a short url's expiration when it is called, compare it to the current time/date, redirect if it's later, and send an error response if it's earlier.

This obviously doesn't provide especially fine-grained control over the short url expiration behavior. If we wanted more control or more powerful implicit expiration behavior (maybe our rule is that short urls are updatable and expire by default 30 days after they are last updated), I might implement an append-only events table that records updates to short urls. From the events table, expiration dates could be calculated and updates could be easily rolled back and replayed.
