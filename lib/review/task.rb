require 'review/task/version'
require 'review/task/rake_task'
require 'review/task/md2review'

module ReVIEW
  module Task
    module_function

    def plugins
      {
        md2review: ReVIEW::Task::MD2ReVIEW
      }
    end
  end
end
