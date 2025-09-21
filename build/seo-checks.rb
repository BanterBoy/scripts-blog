#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'yaml'
require 'time'
require 'date'
require 'webrick'
require 'net/http'
require 'uri'
require 'rexml/document'
require 'rexml/xpath'

ROOT = File.expand_path('..', __dir__)
SITE_DIR = File.expand_path('../_site', __dir__)
CONFIG_PATH = File.join(ROOT, '_config.yml')
LYCHEE_PATH = File.join(ROOT, 'lychee-report.json')
OUTPUT_PATH = File.join(ROOT, 'seo-checks.json')

abort("Build directory not found: #{SITE_DIR}") unless Dir.exist?(SITE_DIR)
abort("Config file not found: #{CONFIG_PATH}") unless File.file?(CONFIG_PATH)

config = YAML.safe_load(File.read(CONFIG_PATH), permitted_classes: [Date]) || {}
site_url = config['url']
site_host = begin
  URI(site_url).host if site_url
rescue URI::InvalidURIError
  nil
end
allowed_noindex = Array(config.dig('seo', 'noindex_allowlist')).map(&:to_s)

warnings = []

sitemap_path = File.join(SITE_DIR, 'sitemap.xml')
sitemap_present = File.file?(sitemap_path)
sitemap_urls = []
if sitemap_present
  begin
    xml = REXML::Document.new(File.read(sitemap_path))
    REXML::XPath.each(xml, '//url/loc') do |loc|
      sitemap_urls << loc.text.strip
    end
  rescue StandardError => e
    warnings << "Failed to parse sitemap.xml: #{e.message}"
  end
else
  warnings << 'sitemap.xml is missing from the build output'
end

html_files = Dir.glob(File.join(SITE_DIR, '**', '*.html'))
canonical_map = {}
missing_canonicals = []
noindex_pages = []
refresh_pages = []

html_files.each do |html_path|
  rel_path = html_path.delete_prefix(SITE_DIR + '/').sub(%r{^/}, '')
  content = File.read(html_path, encoding: 'UTF-8', invalid: :replace, undef: :replace, replace: '')

  canonical_url = nil
  # Find all <link ...> tags, then check for rel="canonical" and extract href
  link_tags = content.scan(/<link[^>]*>/i)
  tag = link_tags.find { |t| t =~ /\brel=['"]canonical['"]/i }
  if tag && tag =~ /\bhref=['"]([^'"]+)['"]/i
    canonical_url = $1.strip
  end

  noindex_flag = false
  if (content =~ /<meta\s[^>]*name=(['"])robots\1[^>]*content=(['"])(.*?)\2/i)
    robots_value = Regexp.last_match(3).downcase
    if robots_value.include?('noindex')
      noindex_flag = true
      noindex_pages << rel_path
    end
  end

  if canonical_url
    canonical_map[rel_path] = canonical_url
  elsif !noindex_flag
    missing_canonicals << rel_path
  end

  refresh_pages << rel_path if content =~ /http-equiv=(['"])refresh\1/i
end

server = WEBrick::HTTPServer.new(
  Port: 4123,
  DocumentRoot: SITE_DIR,
  AccessLog: [],
  Logger: WEBrick::Log.new($stderr, WEBrick::Log::WARN)
)

canonical_checks = []
server_thread = nil

begin
  server_thread = Thread.new { server.start }
  sleep 0.5

  http = Net::HTTP.new('127.0.0.1', server.config[:Port])
  http.read_timeout = 10
  http.open_timeout = 5

  canonical_map.each do |rel_path, canonical_url|
    begin
      uri = URI.parse(canonical_url)
    rescue URI::InvalidURIError
      canonical_checks << {
        'file' => rel_path,
        'canonical' => canonical_url,
        'http_status' => nil,
        'error' => 'invalid canonical URL'
      }
      next
    end

    if site_host && uri.host && uri.host != site_host
      warnings << "Canonical host mismatch for #{rel_path}: #{canonical_url}"
    end

    request_path = uri.path.to_s
    request_path = '/' if request_path.empty?
    request_path += "?#{uri.query}" if uri.query

    begin
      response = http.get(request_path)
      canonical_checks << {
        'file' => rel_path,
        'canonical' => canonical_url,
        'http_status' => response.code.to_i
      }
    rescue StandardError => e
      canonical_checks << {
        'file' => rel_path,
        'canonical' => canonical_url,
        'http_status' => nil,
        'error' => e.message
      }
    end
  end
ensure
  server.shutdown
  server_thread&.join
end

lychee_report = nil
if File.file?(LYCHEE_PATH)
  begin
    lychee_report = JSON.parse(File.read(LYCHEE_PATH))
  rescue StandardError => e
    warnings << "Failed to parse lychee report: #{e.message}"
  end
end

unique_noindex = noindex_pages.uniq.sort
unexpected_noindex = unique_noindex - allowed_noindex

results = {
  'generated_at' => Time.now.utc.iso8601,
  'site_url' => site_url,
  'sitemap_present' => sitemap_present,
  'sitemap_url_count' => sitemap_urls.length,
  'sitemap_urls' => sitemap_urls,
  'pages_scanned' => html_files.length,
  'missing_canonicals' => missing_canonicals.sort,
  'canonical_checks' => canonical_checks,
  'noindex_pages' => unique_noindex,
  'unexpected_noindex' => unexpected_noindex,
  'meta_refresh_pages' => refresh_pages.uniq.sort,
  'lychee_report' => lychee_report,
  'warnings' => warnings.uniq
}

File.write(OUTPUT_PATH, JSON.pretty_generate(results))
puts "SEO checks written to #{OUTPUT_PATH}"
