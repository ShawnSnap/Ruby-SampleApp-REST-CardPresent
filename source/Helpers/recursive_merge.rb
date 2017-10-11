module Evo
  def self.recursive_merge(default, request)
    request.keys.each do |k|
      default[k] = if default[k].is_a?(Hash) && request[k].is_a?(Hash)
                     recursive_merge(default[k], request[k])
                   else
                     request[k]
                   end
    end
    default
  end
end
