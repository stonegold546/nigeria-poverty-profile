require 'sinatra'
require 'slim'
require 'slim/include'
require 'rack-ssl-enforcer'
require 'json'
require 'csv'
require 'tilt/kramdown'
require 'ap'
require 'chartkick'

# The Nigerian Poverty Profile visualizer
class NigeriaPovertyProfile < Sinatra::Base
  POPN = 'estimated_population'

  ng_re = File.open('./data/maps/ng-re.json')
  ng_re = JSON.load ng_re
  ng_re = ng_re.to_json
  ng_nc = File.open('./data/maps/ng-nc.json')
  ng_nc = JSON.load ng_nc
  ng_nc = ng_nc.to_json
  ng_ne = File.open('./data/maps/ng-ne.json')
  ng_ne = JSON.load ng_ne
  ng_ne = ng_ne.to_json
  ng_nw = File.open('./data/maps/ng-nw.json')
  ng_nw = JSON.load ng_nw
  ng_nw = ng_nw.to_json
  ng_se = File.open('./data/maps/ng-se.json')
  ng_se = JSON.load ng_se
  ng_se = ng_se.to_json
  ng_ss = File.open('./data/maps/ng-ss.json')
  ng_ss = JSON.load ng_ss
  ng_ss = ng_ss.to_json
  ng_sw = File.open('./data/maps/ng-sw.json')
  ng_sw = JSON.load ng_sw
  ng_sw = ng_sw.to_json
  ng_all = File.open('./data/maps/ng-all.json')
  ng_all = JSON.load ng_all
  ng_all = ng_all.to_json

  food_absolute_relative_dollar_poverty =
  Hash.new { |hash, key| hash[key] = {} }

  household_assessment = Hash.new { |hash, key| hash[key] = {} }

  relative_poverty_over_time_groups =
  Hash.new { |hash, key| hash[key] = {} }

  relative_poverty_over_time_incidence =
  Hash.new { |hash, key| hash[key] = {} }

  CSV.foreach('./data/csv/food_absolute_relative_dollar_poverty.csv')
    .each_with_index do |row, index|
    next if index == 0
    temp = { row[1] => {
      'food_poor' => row[2].to_f, 'food_non_poor' => row[3].to_f,
      'absolute_poor' => row[4].to_f, 'absolute_non_poor' => row[5].to_f,
      'relative_poor' => row[6].to_f, 'relative_non_poor' => row[7].to_f,
      'dollar_poor' => row[8].to_f, 'dollar_non_poor' => row[9].to_f
    } }
    food_absolute_relative_dollar_poverty[row[0]] =
    food_absolute_relative_dollar_poverty[row[0]].merge temp
  end

  CSV.foreach('./data/csv/household_assessment.csv')
    .each_with_index do |row, index|
    next if index == 0
    temp = { row[1] => {
      'very_poor' => row[2].to_f, 'poor' => row[3].to_f,
      'moderate' => row[4].to_f, 'fairly_rich' => row[5].to_f,
      'rich' => row[6].to_f
    } }
    household_assessment[row[0]] = household_assessment[row[0]].merge temp
  end

  CSV.foreach('./data/csv/relative_poverty_over_time_groups.csv')
    .each_with_index do |row, index|
    next if index == 0
    temp = { row[0] => {
      'non_poor' => row[1].to_f, 'moderately_poor' => row[2].to_f,
      'extremely_poor' => row[3].to_f
    } }
    relative_poverty_over_time_groups =
    relative_poverty_over_time_groups.merge temp
  end

  CSV.foreach('./data/csv/relative_poverty_over_time_incidence.csv')
    .each_with_index do |row, index|
    next if index == 0
    temp = { row[0] => {
      'poverty_incidence' => row[1].to_f, 'estimated_population' => row[2].to_f,
      'population_in_poverty' => row[3].to_f
    } }
    relative_poverty_over_time_incidence =
    relative_poverty_over_time_incidence.merge temp
  end

  food_poverty_by_region, absolute_poverty_by_region,
  relative_poverty_by_region, dollar_poverty_by_region,
  food_poverty_by_state, absolute_poverty_by_state,
  relative_poverty_by_state, dollar_poverty_by_state =
  %w(zone state).map do |region_type|
    %w(food_poor absolute_poor relative_poor dollar_poor).map do |type|
      food_absolute_relative_dollar_poverty[region_type].map do |key, values|
        result = []
        values.each do |e, v|
          result = { 'name' => key, 'value' => v } if e == type
        end
        result
      end.to_json
    end
  end.flatten

  group_keys = relative_poverty_over_time_groups.map { |k, _| k }.to_json

  relative_poverty_over_time_groups =
  relative_poverty_over_time_groups.map do |_, data|
    data.map do |key, value|
      key = key == 'non_poor' ? key.tr('_', '-') : key.tr('_', ' ')
      [key.capitalize, value]
    end
  end

  group_values =
  relative_poverty_over_time_groups.transpose.map do |values|
    {
      name: values.map { |e| e[0] }[0],
      data: values.each_with_index.map do |e, idx|
        e[1] * relative_poverty_over_time_incidence.values[idx][POPN] / 100
      end
    }
  end.to_json

  get '/' do
    slim :index, locals: {
      food_poverty_by_region: food_poverty_by_region,
      absolute_poverty_by_region: absolute_poverty_by_region,
      relative_poverty_by_region: relative_poverty_by_region,
      dollar_poverty_by_region: dollar_poverty_by_region,
      food_poverty_by_state: food_poverty_by_state,
      absolute_poverty_by_state: absolute_poverty_by_state,
      relative_poverty_by_state: relative_poverty_by_state,
      dollar_poverty_by_state: dollar_poverty_by_state,
      ng_re: ng_re, ng_nc: ng_nc, ng_ne: ng_ne, ng_nw: ng_nw,
      ng_ss: ng_ss, ng_sw: ng_sw, ng_se: ng_se, ng_all: ng_all,
      group_keys: group_keys, group_values: group_values
    }
  end

  get '/keybase.txt' do
    File.read(File.join('public', 'keybase.txt'))
  end
end
