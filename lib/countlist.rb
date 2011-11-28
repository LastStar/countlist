require 'yaml'
module Countlist
  VERSION = '0.1.0'

  module Countries
    def countries
      @countries ||= YAML::load(data_file('en.yml'))
    end

    def iso_codes
      @iso_codes ||= YAML::load(data_file('iso.yml'))
    end

    def country_code(country_name)
      countries.detect {|k, v| v == country_name}.first
    end

    def iso_code(country_code)
      iso_codes[country_code].first
    end

    def number_iso_code(country_code)
      iso_codes[country_code].last
    end

    def country_names
      countries.map {|k, v| v}
    end

    def states(country)
      @states ||= {}
      @states[country] ||= YAML::load(data_file("states/#{country.downcase}.yml"))
    end

    def countries_with_states
      Dir[File.join(data_dir, 'states/*.yml')].map do |f|
        File.basename(f).split('.').first.upcase
      end
    end

    private
    def data_dir
      File.expand_path(File.join(File.dirname(__FILE__), '../data'))
    end

    def data_file(file)
      File.read(File.join(data_dir, file))
    end
  end

end
