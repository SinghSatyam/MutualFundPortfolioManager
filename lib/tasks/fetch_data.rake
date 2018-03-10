namespace :kuverapms do
  desc 'Fetch Data Every Night from AMFI'
  task :fetch_last_few_days_data => :environment do
    puts "Fetching Data For Last 7 Days"
    FetchDataService.new.fetch_data(DateTime.now-7.days,DateTime.now)
  end

  desc 'Delete All Data And Re-Get Data from AMFI till date'
  task :pristine_all_data => :environment do
    Puts "Cleaning MutualFundNavMaster & Re-Inserting All Data"
    FetchDataService.new.pristine_all_data
  end

  desc 'Process All Unprocessed Investments'
  task :process_unprocesses_investment => :environment do
    puts "Processing unprocessed data"
    puts "Unprocessed in system: #{Investment.where(:processed=>false).count}"
    Investment.where(:processed=>false).find_each do |investment|
      investment.calculate_unit_allotted
    end
    puts "Unprocessed in system left: #{Investment.where(:processed=>false).count}"
  end  

end