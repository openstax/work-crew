module WorkCrew
  class Engine < ::Rails::Engine
    isolate_namespace WorkCrew

    initializer "work_crew.factories",
                after: "factory_bot.set_factory_paths" do
      FactoryBot.definition_file_paths << File.join(
        root, 'spec', 'factories', 'work_crew'
      ) if defined?(FactoryBot)
    end

    config.generators.api_only = true
  end
end
