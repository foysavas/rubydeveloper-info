module Merb
  module GlobalHelpers
    # helpers defined here available to all views. 
    def remote_url(val)
      if val.split("://").size == 2
        val
      else
        "http://" + val
      end
    end 
  end
end
