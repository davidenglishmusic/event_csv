require 'open-uri'
require 'nokogiri'

class Clerk

  CALENDAR_SELECTOR = '.calendar-wrap'
  ARTICLE_SELECTOR = 'article'
  EVENT_TITLE_SELECTOR = '.event-info.title'
  DATE_SELECTOR = '.date'
  TIME_SELECTOR = '.time'
  LOCATION_NAME_SELECTOR = '.fn.org'
  ADDRESS_SELECTOR = '.address'
  CITY_SELECTOR = '.city'
  EXTRA_INFORMATION_SELECTOR = 'p'
  CSV_OPENING_LINE = "Subject,Start Date,Start Time,Location,Extra Information\n"

  attr_accessor :calendar

  def initialize(url)
    convert_url_to_nokogiri(url)
  end

  def convert_url_to_nokogiri(url)
    @calendar = Nokogiri::HTML(open(url)).css(CALENDAR_SELECTOR)
  end

  def build_csv
    csv = ''
    csv << CSV_OPENING_LINE
    @calendar.css(ARTICLE_SELECTOR).each do |event|
      csv << get_event_info(event)
    end
    csv
  end

  private

  def get_event_info(event)
    info = ''
    info << event.css(EVENT_TITLE_SELECTOR).to_s.scan(/<p class="event-info title">(.*?)</).join + ','
    info << cleanse_of_commas(event.css(DATE_SELECTOR)[0].to_s.scan(/,(.*?)</).join) + ','
    info << event.css(TIME_SELECTOR)[0].to_s.scan(/<span class="time">(.*?)</).join + ','
    info << cleanse_of_html_code(event.css(LOCATION_NAME_SELECTOR).to_s.to_s.scan(/<span class="fn org">(.*?)</).join) + ' - '
    info << event.css(ADDRESS_SELECTOR).to_s.scan(/<span class="address">(.*?)</).join + ' '
    info << event.css('.city').to_s.scan(/<span class="city">(.*?)</).join + ','
    if buying_option?(event.css(EXTRA_INFORMATION_SELECTOR)[4].to_s)
      info << ' '
    else
      info << event.css('p')[4].to_s.scan(/<p>(.*?)</).join
    end
    info << "\n"
  end

  def buying_option?(element)
    if element.to_s == '<p class="event-info buying-options">

      </p>'
      true
    else
      false
    end
  end

  def cleanse_of_commas(element)
    element.sub(',', '')
  end

  def cleanse_of_html_code(element)
    element.sub('&amp;', '&').sub('<br />', ' - ')
  end
end
