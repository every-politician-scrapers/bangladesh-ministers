#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'

require 'pry'

class MemberList
  class Member
    field :name do
      tds[2].text.tidy
    end

    field :position do
      tds[5].text.tidy.split(/(?=Ministry )/).map(&:tidy).map do |posn|
        posn.start_with?('Ministry') ? posn.sub('Ministry', 'Minister') : nil
      end.compact
    end

    field :start_date do
      tds[6].text.tidy.split('-').reverse.join('-')
    end

    private

    def tds
      noko.css('td')
    end
  end

  class Members
    def member_container
      noko.xpath('.//tr[contains(., "Ministers")]/following-sibling::tr').drop(1)
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
