after "deploy:updated", "sidekiq:start"
after "deploy:finishing", "sidekiq:stop"

namespace :sidekiq do
  desc "Start Sidekiq"
  task :start do
    on roles(:app) do
      # 실서버에서 실행되는 `sidekiq` 명령어를 호출합니다.
      execute "sidekiq"
    end
  end

  desc "Stop Sidekiq"
  task :stop do
    on roles(:app) do
      # 실서버에서 실행되는 `sidekiq stop` 명령어를 호출합니다.
      execute "sidekiq stop"
    end
  end
end
