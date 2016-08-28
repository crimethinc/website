def WebConsole.caller_bindings
  locations = ::Rubinius::VM.backtrace(1, true)

  # Kernel.raise, is implemented in Ruby for Rubinius. We don't wanna have
  # the frame for it to align with the CRuby and JRuby implementations.
  #
  # For internal methods location variables can be nil. We can't create a
  # bindings for them.
  locations.reject! do |location|
    location.file.start_with?('kernel/delta/kernel.rb') || location.variables.nil?
  end

  bindings = locations.map do |location|
    Binding.setup(
      location.variables,
      location.variables.method,
      location.constant_scope,
      location.variables.self,
      location
    )
  end

  # Drop the binding of the direct caller. That one can be created by
  # Kernel#binding.
  bindings.drop(1)
end

::Rubinius.singleton_class.class_eval do
  def raise_exception_with_current_bindings(exc)
    if exc.bindings.empty?
      exc.instance_variable_set(:@bindings, WebConsole.caller_bindings)
    end

    raise_exception_without_current_bindings(exc)
  end

  alias_method :raise_exception_without_current_bindings, :raise_exception
  alias_method :raise_exception, :raise_exception_with_current_bindings
end
