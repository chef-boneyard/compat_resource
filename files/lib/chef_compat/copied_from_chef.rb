class Chef
end

module ChefCompat
  module CopiedFromChef
    class Chef
      # The ChefCompat::Chef class is just like Chef, but with a few overrides.
      def self.method_missing(name, *args, &block)
        ::Chef.send(name, *args, &block)
      end
      def self.const_missing(name)
        ::Chef.const_get(name)
      end
    end
  end
end
