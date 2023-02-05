setup:
	bundle install

start:
	bundle exec rackup

lint:
	bundle exec rubocop

autocorrect:
	bundle exec rubocop -A

check: lint