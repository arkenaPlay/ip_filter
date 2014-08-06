require 'ip_filter'

module IpFilter
  module Request
    def location
      # For now just grab the first value as the best guess.
      @location ||= IpFilter.search(remote_first_ip).first
    end

    def remote_first_ip
      ip_for_lookup = env["HTTP_X_FORWARDED_FOR"].try(:split, ',').try(:first) || ip
    end
  end
end

if defined?(Rack) and defined?(Rack::Request)
  Rack::Request.send :include, IpFilter::Request
end
