require "eventmachine"

module EM
  class Worker
    def initialize(options={})
      @task_queue = EM::Queue.new
      @concurrency = options.fetch(:concurrency, 10)
      start
    end

    def enqueue(task=nil, callback=nil, options={}, &block)
      task ||= block || Proc.new {}
      @task_queue.push([task, callback, options])
      true
    end

    private

    def do_task
      @task_queue.pop do |task, callback, options|
        EM.defer(task, Proc.new { |result| callback.call(result) if callback; do_task })
      end
    end

    def start
      @concurrency.times do
        EM.next_tick do
          do_task
        end
      end
    end
  end
end
