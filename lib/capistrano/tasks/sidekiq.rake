# Sidekiq

namespace :sidekiq do
  desc "Start Sidekiq"
  task :start do
    on roles(:app) do
      execute "sudo systemctl start sidekiq"
    end
  end

  desc "Stop Sidekiq"
  task :stop do
    on roles(:app) do
      execute "sudo systemctl stop sidekiq"
    end
  end

  desc "Restart Sidekiq"
  task :restart do
    on roles(:app) do
      execute "sudo systemctl restart sidekiq"
    end
  end

  desc "Quiet Sidekiq"
  task :quiet do
    on roles(:app) do
      execute "sudo systemctl kill -s TSTP sidekiq"
    end
  end

  after "deploy:starting", "sidekiq:quiet" if Rake::Task.task_defined?("sidekiq:quiet")
  after "deploy:updated", "sidekiq:stop"
  after "deploy:published", "sidekiq:start"
  after "deploy:failed", "sidekiq:restart"
end
