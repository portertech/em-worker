module AsyncHelpers
  def timer(delay, &block)
    periodic_timer = EM::PeriodicTimer.new(delay) do
      block.call
      periodic_timer.cancel
    end
  end

  def async_wrapper(&block)
    EM::run do
      timer(10) do
        raise "test timed out"
      end
      block.call
    end
  end

  def async_done
    EM::stop_event_loop
  end
end
