# EM::Worker

Provides a simple task worker for EventMachine, with a task concurrency limit. Tasks are executed in the EventMachine threadpool.

[![Build Status](https://secure.travis-ci.org/portertech/em-worker.png)](https://travis-ci.org/portertech/em-worker)

## Installation

Add this line to your application's Gemfile:

    gem 'em-worker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install em-worker

## Usage

``` ruby
  @worker = EM::Worker.new(:concurrency => 12) # defaults to 10

  @worker.enqueue do
    puts "winning"
  end

  task = Proc.new { "tiger blood" }
  callback = Proc.new do |result|
    puts result
  end
  @worker.enqueue(task, callback)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
