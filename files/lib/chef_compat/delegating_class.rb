module ChefCompat
  module DelegatingClass
    def method_missing(name, *args, &block)
      @delegates_to.send(name, *args, &block)
    end
    def const_missing(name)
      @delegates_to.const_get(name)
    end
  end
end
