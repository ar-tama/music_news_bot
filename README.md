# Setup

Set up your Heroku, Slack and Azure environments.

- `ENV['AZURE_KEY']` ... Azure Bing search API key

# Run on Heroku

`bundle exec rackup config.ru -p $PORT` as `web`

## Fetch the news your own schedules

Install [Cron To Go](https://devcenter.heroku.com/articles/crontogo) and run `rake batch:run_crawler`.

