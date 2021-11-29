#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'json'

issue = ARGV[0]

unless issue
  puts 'Please provide an issue number'

  exit 1
end

jira_server = ENV['JIRA_SERVER']
jira_user = ENV['JIRA_USER']
jira_token = ENV['JIRA_API_TOKEN']

unless jira_server && jira_user && jira_token
  puts 'please set JIRA_SERVER, JIRA_USER and JIRA_API_TOKEN'

  exit 1
end

issue = issue.downcase
uri = URI("#{jira_server}/rest/api/2/issue/#{issue}")
req = Net::HTTP::Get.new(uri.request_uri)

req.basic_auth jira_user, jira_token

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
  http.request(req)
end

body = JSON.parse(res.body)

summary = body['fields']['summary']
          .downcase
          .strip # trim spaces
          .gsub(/\W+/, '-') # non alphabetical chars to -
          .gsub(/-+/, '-') # remove duplicated -
          .gsub(/-$/, '') # remove trailing -

summary = summary[0..69] # this ensures we don't hit limits in some tools (e.g Netlify)

# remove project prefix
issue_id = issue.gsub(/^\w+-/, '')

`git checkout -b #{issue_id}-#{summary}`
