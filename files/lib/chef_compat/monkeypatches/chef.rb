class Chef
  NOT_PASSED = Object.new if !defined?(NOT_PASSED)
  # Earlier versions of Chef didn't have this message
  if !respond_to?(:log_deprecation)
    def self.log_deprecation(message)
      Chef::Log.warn(message)
    end
  end
end
