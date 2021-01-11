namespace :vite do
  task init: :environment do
    Rake::Task["vite:init"].invoke
  end

  desc "Removes compiled assets"
  task clobber: :environment do
    build_dir = Rails.root.join(ViteRb.config.build_dir)
    output_dir = File.join(build_dir, ViteRb.config.output_dir)
    command = "rm -rf #{output_dir}"
    logger = Logger.new(STDOUT)
    logger.info(command)
    system(command)
  end

  task build: :environment do
    Rake::Task["vite:build"].invoke
  end

  task dev: :environment do
    Rake::Task["vite:dev"].invoke
  end
end

Rake::Task["assets:precompile"].enhance do
  Rake::Task["vite:build"].invoke
end

Rake::Task["assets:clobber"].enhance do
  Rake::Task["vite:clobber"].invoke
end
