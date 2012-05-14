require 'yaml'
module Countlist
  VERSION = '0.2.0'

  module Countries
    def countries
      @countries ||= YAML::load(data_file('en.yml'))
      if @importance && !@importance.empty?
        a = {}
        @importance.each do |code|
          a[code] = @countries.delete(code)
        end
        @countries = a.merge(@countries)
      end

      return @countries
    end

    def iso_codes
      @iso_codes ||= YAML::load(data_file('iso.yml'))
    end

    def code_of(country_name)
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

    def states_names(country)
      states(country).map {|k, v| v}
    end

    def countries_with_states
      Dir[File.join(data_dir, 'states/*.yml')].map do |f|
        File.basename(f).split('.').first.upcase
      end
    end

    def in_EU?(country)
      @eu ||= YAML::load(organization_file('eu'))
      @eu.include? country
    end

    def importance=(sort)
      @importance = sort
    end

    private
    def data_dir
      File.expand_path(File.join(File.dirname(__FILE__), '../data'))
    end

    def data_file(file)
      File.read(File.join(data_dir, file))
    end

    def organization_file(code)
      File.read(File.join(data_dir, '/organizations/', code + '.yml'))
    end
  end

end
