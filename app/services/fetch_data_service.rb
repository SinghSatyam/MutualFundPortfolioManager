require 'open-uri'
class FetchDataService

  def initialize()
    @line_seperator="\r\n"
  end

  def pristine_all_data
    MutualFundNavMaster.delete_all
    response = fetch_response_from_amfi Date.new(2015,04,01).strftime("%d-%b-%Y"), DateTime.now.strftime("%d-%b-%Y")
    all_lines=response.split(@line_seperator)
    records_to_be_created=[]
    all_lines.each do |line|
      if line_is_valid? line
        splitted_line=line.split(';')
        scheme_code, scheme_name, nav, date = splitted_line[0],splitted_line[1],splitted_line[2],splitted_line[5]
        records_to_be_created<<MutualFundNavMaster.new(scheme_code: scheme_code, scheme_name: scheme_name, nav: nav, date: date)
      end
    end
    MutualFundNavMaster.import(records_to_be_created)
  end

  def fetch_all_data
    fetch_data(Date.new(2015,04,01), DateTime.now)
  end
  
  def fetch_data(start_date,end_date)
    response = fetch_response_from_amfi start_date.strftime("%d-%b-%Y"), end_date.strftime("%d-%b-%Y")
    all_lines=response.split(@line_seperator)
    ActiveRecord::Base.transaction do
        all_lines.each do |line|
          if line_is_valid? line
            create_mf_nav_master line
          end
        end
    end
  end

  private

  def fetch_response_from_amfi from_date, to_date
    open("http://portal.amfiindia.com/DownloadNAVHistoryReport_Po.aspx?mf=53&tp=1&frmdt=#{from_date}&todt=#{to_date}").read
  end

  def create_mf_nav_master line
    splitted_line=line.split(';')

    scheme_code, scheme_name, nav, date = splitted_line[0],splitted_line[1],splitted_line[2],splitted_line[5]
    MutualFundNavMaster.find_or_create_by(scheme_code: scheme_code,date: date) do |mfnavm|
      mfnavm.scheme_name = scheme_name
      mfnavm.nav = nav
    end
  end
  
  def line_is_valid? line_string
  return_value=true
  return_value=line_is_empty?(line_string)
  return_value=return_value && first_seperator_is_code?(line_string)
  return return_value
  end

  def line_is_empty? line_string
  (line_string.present?) ? true : false 
  end

  def first_seperator_is_code? line_string
  check_string(line_string.split(';')[0])
  end


  def check_string string
    string.scan(/\D/).empty?
  end

end

