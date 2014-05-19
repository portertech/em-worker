require "spec_helper"
require "async_helpers"
require File.dirname(__FILE__) + "/../lib/em/worker.rb"

describe "EM::Worker" do
  include AsyncHelpers

  before do
    @worker = EM::Worker.new
  end

  it "can enqueue a task" do
    async_wrapper do
      @worker.enqueue do
        puts "winning"
      end.should eql true
      async_done
    end
  end

  it "does work" do
    async_wrapper do
      task = Proc.new { "tiger blood" }
      callback = Proc.new do |result|
        result.should eql "tiger blood"
        async_done
      end
      @worker.enqueue(task, callback)
    end
  end

  it "will do a maximum of 12 tasks at a time by default" do
    @concurrency = Queue.new
    async_wrapper do
      24.times do
        @worker.enqueue do
          @concurrency << 1
          sleep 1000
        end
      end
      timer(1) do
        @concurrency.size.should eql 12
        async_done
      end
    end
  end

  it "will complete tasks" do
    @results = []
    async_wrapper do
      1000.times do |i|
        task = Proc.new { i }
        callback = Proc.new do |result|
          @results << result
        end
        @worker.enqueue(task, callback)
      end
      timer(2) do
        @results.size.should eql 1000
        async_done
      end
    end
  end
end
