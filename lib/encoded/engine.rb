module Encoded
  class Engine < ::Rails::Engine
    config.autoload_paths += %W(#{config.root}/lib/)

    isolate_namespace Encoded
  end
end