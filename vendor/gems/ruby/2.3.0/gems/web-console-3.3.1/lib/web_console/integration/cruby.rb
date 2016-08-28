require 'debug_inspector'

def WebConsole.caller_bindings
  bindings = RubyVM::DebugInspector.open do |context|
    context.backtrace_locations.each_index.map { |i| context.frame_binding(i) }
  end

  # For C functions, we can't extract a binding. In this case,
  # DebugInspector#frame_binding would have returned us nil. That's why we need
  # to compact the bindings.
  #
  # Dropping two bindings, removes the current Ruby one in this exact method,
  # and the one in the caller method. The caller method binding can be obtained
  # by Kernel#binding, if needed.
  bindings.compact.drop(2)
end

TracePoint.trace(:raise) do |context|
  exc = context.raised_exception
  if exc.bindings.empty?
    exc.instance_variable_set(:@bindings, WebConsole.caller_bindings)
  end
end
