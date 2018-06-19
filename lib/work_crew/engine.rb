module WorkCrew
  class Engine < ::Rails::Engine
    isolate_namespace WorkCrew
    config.generators.api_only = true
  end
end
