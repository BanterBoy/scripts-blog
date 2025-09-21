#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'yaml'
require 'time'
require 'date'
require 'optparse'
require 'net/http'
require 'uri'
require 'rexml/document'
require 'rexml/xpath'
require 'set'

ROOT = File.expand_path('..', __dir__)
DEFAULT_SITE_DIR = File.expand_path('../_site', __dir__)
DEFAULT_OUT_PATH = File.join(ROOT, 'seo-checks.json')
DEFAULT_ALLOWLIST_PATH = File.join(ROOT, 'build', 'seo-allowlist.yml')
CONFIG_PATH = File.join(ROOT, '_config.yml')
LYCHEE_PATH = File.join(ROOT, 'lychee-report.json')

options = {
  site: DEFAULT_SITE_DIR,
  out: DEFAULT_OUT_PATH,
  allowlist: DEFAULT_ALLOWLIST_PATH
}

OptionParser.new do |opts|
  opts.banner = 'Usage: seo-checks.rb [options]'

  opts.on('--site PATH', 'Path to the built site directory (default: ./_site)') do |path|
    options[:site] = path
  end

  opts.on('--out PATH', 'Output path for seo-checks.json (default: ./seo-checks.json)') do |path|
    options[:out] = path
  end

  opts.on('--allowlist PATH', 'Path to allowlist YAML (default: ./build/seo-allowlist.yml)') do |path|
    options[:allowlist] = path
  end

  opts.on('-h', '--help', 'Show this help message') do
    puts opts
    exit
  end
end.parse!(ARGV)

site_dir = File.expand_path(options[:site])
out_path = File.expand_path(options[:out])
allowlist_path = options[:allowlist] && !options[:allowlist].empty? ? File.expand_path(options[:allowlist]) : nil

abort("Build directory not found: #{site_dir}") unless Dir.exist?(site_dir)
abort("Config file not found: #{CONFIG_PATH}") unless File.file?(CONFIG_PATH)

config = YAML.safe_load(File.read(CONFIG_PATH), permitted_classes: [Date]) || {}
site_url = config['url']
site_host = begin
  URI(site_url).host if site_url
rescue URI::InvalidURIError
  nil
end
allowed_noindex_patterns = Array(config.dig('seo', 'noindex_allowlist')).map(&:to_s)

soft_fail_warnings = ENV.fetch('SEO_SOFT_FAIL_WARNINGS', 'false').to_s.downcase == 'true'
sitemap_optional = ENV.fetch('SEO_SITEMAP_OPTIONAL', 'false').to_s.downcase == 'true'
ci_environment = ENV.fetch('CI', nil)

allowlist_patterns = []
allowlist_warning = nil
if allowlist_path && File.exist?(allowlist_path)
  begin
    raw_allowlist = YAML.safe_load(File.read(allowlist_path))
    allowlist_patterns =
      case raw_allowlist
      when Array
        raw_allowlist
      when Hash
        raw_allowlist.values.flatten
      else
        []
      end
    allowlist_patterns = Array(allowlist_patterns).compact.map(&:to_s)
  rescue StandardError => e
    allowlist_warning = "Failed to load allowlist #{allowlist_path}: #{e.message}"
  end
end

FNM_FLAGS = File::FNM_CASEFOLD | File::FNM_PATHNAME | (defined?(File::FNM_EXTGLOB) ? File::FNM_EXTGLOB : 0)

def allowlisted?(patterns, candidate)
  return false if candidate.nil?

  value_str = candidate.to_s
  values = [value_str]
  values << value_str.delete_prefix('/') if value_str.start_with?('/')
  values << "/#{value_str}" unless value_str.start_with?('/')
  values.uniq.any? do |value|
    patterns.any? do |pattern|
      next false if pattern.nil?

      pattern_str = pattern.to_s
      match = begin
        File.fnmatch?(pattern_str, value, FNM_FLAGS)
      rescue ArgumentError
        false
      end
      match || (!pattern_str.empty? && value.include?(pattern_str))
    end
  end
end

def http_get_with_retries(uri, attempts: 3, open_timeout: 5, read_timeout: 10)
  last_error = nil
  attempts.times do |attempt|
    begin
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: open_timeout, read_timeout: read_timeout) do |http|
        request_uri = uri.request_uri
        request_uri = '/' if request_uri.nil? || request_uri.empty?
        response = http.request(Net::HTTP::Get.new(request_uri))
        return response
      end
    rescue StandardError => e
      last_error = e
      sleep(0.5 * (attempt + 1)) if attempt < attempts - 1
    end
  end
  raise last_error if last_error
end

def canonical_local_path(site_dir, uri, site_url)
  return nil unless uri

  site_uri = begin
    URI(site_url) if site_url
  rescue URI::InvalidURIError
    nil
  end

  path =
    if uri.scheme.nil? || uri.host.nil?
      uri.path
    elsif site_uri && uri.host == site_uri.host
      uri.path
    else
      nil
    end

  return nil unless path

  normalized = path.empty? ? '/' : path
  normalized = normalized.split('?').first
  normalized = '/' if normalized.nil? || normalized.empty?
  normalized = normalized.sub(%r{^/}, '')

  candidates = []
  if normalized.empty?
    candidates << 'index.html'
  else
    candidates << normalized
    unless normalized.end_with?('.html')
      candidates << File.join(normalized, 'index.html')
      candidates << "#{normalized}.html" unless normalized.include?('.')
    end
  end

  candidates.each do |relative|
    candidate_path = File.join(site_dir, relative)
    return candidate_path if File.file?(candidate_path)
  end

  nil
end

warning_entries = []
warning_seen = Set.new
warnings = []
missing_canonical_set = Set.new
non_200_canonical_entries = []
non_200_seen = Set.new
missing_sitemap_entries = []
missing_sitemap_seen = Set.new
unexpected_noindex_set = Set.new
canonical_checks = []
noindex_pages_set = Set.new
refresh_pages_set = Set.new

if allowlist_warning
  warning_key = [nil, allowlist_warning]
  warning_entries << { 'message' => allowlist_warning }
  warning_seen.add(warning_key)
  warnings << allowlist_warning
  puts "::warning ::SEO: #{allowlist_warning}"
end

sitemap_path = File.join(site_dir, 'sitemap.xml')
sitemap_present = File.file?(sitemap_path)
sitemap_urls = []

if sitemap_present
  begin
    xml = REXML::Document.new(File.read(sitemap_path))
    REXML::XPath.each(xml, '//url/loc') do |loc|
      sitemap_urls << loc.text.to_s.strip
    end
  rescue StandardError => e
    message = "Failed to parse sitemap.xml: #{e.message}"
    warning_key = [nil, message]
    unless warning_seen.include?(warning_key)
      warning_entries << { 'message' => message }
      warning_seen.add(warning_key)
    end
    warnings << message unless warnings.include?(message)
    puts "::warning ::SEO: #{message}"
  end
else
  message = "sitemap.xml is missing from #{site_dir}"
  missing_key = [nil, message]
  unless missing_sitemap_seen.include?(missing_key)
    missing_sitemap_entries << { 'message' => message }
    missing_sitemap_seen.add(missing_key)
  end

  if sitemap_optional
    warning_key = [nil, message]
    unless warning_seen.include?(warning_key)
      warning_entries << { 'message' => message }
      warning_seen.add(warning_key)
    end
    warnings << message unless warnings.include?(message)
    puts "::warning ::SEO: #{message}"
  else
    puts "::error ::SEO: #{message}"
  end
end

remote_sitemap_status = nil
remote_sitemap_error = nil
if !sitemap_present && site_url
  begin
    sitemap_uri = URI.join(site_url, '/sitemap.xml')
    response = http_get_with_retries(sitemap_uri, attempts: 2)
    remote_sitemap_status = response.code.to_i
    if remote_sitemap_status && remote_sitemap_status >= 400
      message = "Remote sitemap returned #{remote_sitemap_status}"
      warning_key = [nil, message]
      unless warning_seen.include?(warning_key)
        warning_entries << { 'message' => message }
        warning_seen.add(warning_key)
      end
      warnings << message unless warnings.include?(message)
      puts "::warning ::SEO: #{message}"
    end
  rescue StandardError => e
    remote_sitemap_error = e.message
    message = "Failed to fetch remote sitemap: #{e.message}"
    warning_key = [nil, message]
    unless warning_seen.include?(warning_key)
      warning_entries << { 'message' => message }
      warning_seen.add(warning_key)
    end
    warnings << message unless warnings.include?(message)
    puts "::warning ::SEO: #{message}"
  end
end

html_files = Dir.glob(File.join(site_dir, '**', '*.html')).sort
canonical_map = {}

html_files.each do |html_path|
  rel_path = html_path.delete_prefix(site_dir + '/').sub(%r{^/}, '')
  allowlisted_page = allowlisted?(allowlist_patterns, rel_path)

  content = File.read(html_path, encoding: 'UTF-8', invalid: :replace, undef: :replace, replace: '')

  canonical_url = nil
  content.scan(/<link[^>]*>/i).each do |tag|
    next unless tag =~ /\brel\s*=\s*['"]canonical['"]/i

    if tag =~ /\bhref\s*=\s*['"]([^'"]+)['"]/i
      canonical_url = Regexp.last_match(1).strip
      break
    end
  end

  noindex_flag = false
  content.scan(/<meta[^>]*>/i).each do |tag|
    next unless tag =~ /\bname\s*=\s*(['"])robots\1/i

    if tag =~ /\bcontent\s*=\s*(['"])(.*?)\1/i
      robots_value = Regexp.last_match(2).downcase
      if robots_value.split(',').map(&:strip).any? { |directive| %w[noindex none].include?(directive) }
        noindex_flag = true
        noindex_pages_set.add(rel_path)
      end
    end
  end

  if canonical_url
    canonical_map[rel_path] = canonical_url
  elsif !noindex_flag && !allowlisted_page
    missing_canonical_set.add(rel_path)
    puts "::warning file=#{rel_path},line=1,col=1::SEO: Missing canonical link"
  end

  refresh_pages_set.add(rel_path) if content =~ /http-equiv\s*=\s*(['"])refresh\1/i
end

canonical_map.each do |rel_path, canonical_url|
  allowlisted_page = allowlisted?(allowlist_patterns, rel_path)
  allowlisted_canonical = allowlisted?(allowlist_patterns, canonical_url)
  canonical_entry = {
    'file' => rel_path,
    'canonical' => canonical_url
  }

  begin
    uri = URI.parse(canonical_url)
  rescue URI::InvalidURIError
    canonical_entry['http_status'] = nil
    canonical_entry['error'] = 'invalid canonical URL'
    canonical_checks << canonical_entry

    unless allowlisted_page || allowlisted_canonical
      message = "Invalid canonical URL for #{rel_path}: #{canonical_url}"
      warning_key = [rel_path, message]
      unless warning_seen.include?(warning_key)
        warning_entries << { 'file' => rel_path, 'message' => message }
        warning_seen.add(warning_key)
      end
      warnings << message unless warnings.include?(message)
      puts "::warning file=#{rel_path},line=1,col=1::SEO: Invalid canonical URL #{canonical_url}"
    end
    next
  end

  local_target = canonical_local_path(site_dir, uri, site_url)

  if site_host && uri.host && uri.host != site_host && !allowlisted_page && !allowlisted_canonical
    message = "Canonical host mismatch for #{rel_path}: #{canonical_url}"
    warning_key = [rel_path, message]
    unless warning_seen.include?(warning_key)
      warning_entries << { 'file' => rel_path, 'message' => message }
      warning_seen.add(warning_key)
    end
    warnings << message unless warnings.include?(message)
    puts "::warning file=#{rel_path},line=1,col=1::SEO: Canonical host mismatch #{canonical_url}"
  end

  if local_target
    canonical_entry['http_status'] = 200
    canonical_checks << canonical_entry
    next
  end

  if uri.host.nil? && !uri.path.to_s.empty? && ci_environment
    # Relative canonical that doesn't map to a local file in CI is a potential issue.
    canonical_entry['http_status'] = nil
    canonical_entry['error'] = 'canonical target missing from local build'
    canonical_checks << canonical_entry

    unless allowlisted_page || allowlisted_canonical
      detail = {
        'page' => rel_path,
        'canonical' => canonical_url,
        'error' => 'canonical target missing from local build'
      }
      detail_key = [rel_path, canonical_url, 'missing_local']
      unless non_200_seen.include?(detail_key)
        non_200_seen.add(detail_key)
        non_200_canonical_entries << detail
      end
      puts "::error file=#{rel_path},line=1,col=1::SEO: Canonical #{canonical_url} not found in local build"
    end
    next
  end

  if uri.host.nil?
    # Attempt to build an absolute URI using site_url if possible.
    begin
      site_uri = URI(site_url) if site_url
    rescue URI::InvalidURIError
      site_uri = nil
    end
    if site_uri
      uri = site_uri.merge(canonical_url)
    else
      canonical_entry['http_status'] = nil
      canonical_entry['error'] = 'unable to resolve canonical host'
      canonical_checks << canonical_entry

      unless allowlisted_page || allowlisted_canonical
        detail = {
          'page' => rel_path,
          'canonical' => canonical_url,
          'error' => 'unable to resolve canonical host'
        }
        detail_key = [rel_path, canonical_url, 'resolve_host']
        unless non_200_seen.include?(detail_key)
          non_200_seen.add(detail_key)
          non_200_canonical_entries << detail
        end
        puts "::error file=#{rel_path},line=1,col=1::SEO: Unable to resolve canonical host for #{canonical_url}"
      end
      next
    end
  end

  begin
    response = http_get_with_retries(uri)
    canonical_entry['http_status'] = response.code.to_i
    canonical_checks << canonical_entry

    next if response.code.to_i.between?(200, 299)

    unless allowlisted_page || allowlisted_canonical
      detail = {
        'page' => rel_path,
        'canonical' => canonical_url,
        'status' => response.code.to_i
      }
      detail_key = [rel_path, canonical_url, response.code.to_i]
      unless non_200_seen.include?(detail_key)
        non_200_seen.add(detail_key)
        non_200_canonical_entries << detail
      end
      puts "::error file=#{rel_path},line=1,col=1::SEO: Canonical #{canonical_url} returned #{response.code}"
    end
  rescue StandardError => e
    canonical_entry['http_status'] = nil
    canonical_entry['error'] = e.message
    canonical_checks << canonical_entry

    unless allowlisted_page || allowlisted_canonical
      detail = {
        'page' => rel_path,
        'canonical' => canonical_url,
        'error' => e.class.to_s
      }
      detail_key = [rel_path, canonical_url, e.class.to_s]
      unless non_200_seen.include?(detail_key)
        non_200_seen.add(detail_key)
        non_200_canonical_entries << detail
      end
      puts "::error file=#{rel_path},line=1,col=1::SEO: Canonical #{canonical_url} request failed (#{e.class})"
    end
  end
end

unique_noindex = noindex_pages_set.to_a.sort

unexpected_noindex = unique_noindex.reject do |path|
  allowlisted?(allowlist_patterns, path) || allowlisted?(allowed_noindex_patterns, path)
end

unexpected_noindex.each do |path|
  unexpected_noindex_set.add(path)
  puts "::error file=#{path},line=1,col=1::SEO: Unexpected noindex"
end

refresh_pages = refresh_pages_set.to_a.sort
missing_canonicals = missing_canonical_set.to_a.sort
non_200_canonicals = non_200_canonical_entries
missing_sitemap = missing_sitemap_entries
unexpected_noindex_list = unexpected_noindex_set.to_a.sort

# Deduplicate warning_entries by message content
seen_messages = Set.new
warning_entries.select! do |entry|
  msg = entry['message'] || entry[:message]
  if seen_messages.include?(msg)
    false
  else
    seen_messages.add(msg)
    true
  end
end

counts = {
  warnings: warning_entries.length,
  missing_canonicals: missing_canonicals.length,
  non_200_canonicals: non_200_canonicals.length,
  missing_sitemap: missing_sitemap.length,
  unexpected_noindex: unexpected_noindex_list.length
}

items = {
  warnings: warning_entries,
  missing_canonicals: missing_canonicals,
  non_200_canonicals: non_200_canonicals,
  missing_sitemap: missing_sitemap,
  unexpected_noindex: unexpected_noindex_list
}

if counts[:missing_canonicals].positive?
  warnings.concat(missing_canonicals.map { |path| "Missing canonical for #{path}" })
end

warnings.uniq!

lychee_report = nil
if File.file?(LYCHEE_PATH)
  begin
    lychee_report = JSON.parse(File.read(LYCHEE_PATH))
  rescue StandardError => e
    message = "Failed to parse lychee report: #{e.message}"
    warning_key = [nil, message]
    unless warning_seen.include?(warning_key)
      warning_entries << { 'message' => message }
      warning_seen.add(warning_key)
    end
    warnings << message unless warnings.include?(message)
    puts "::warning ::SEO: #{message}"
  end
end

results = {
  'generated_at' => Time.now.utc.iso8601,
  'site_url' => site_url,
  'sitemap_present' => sitemap_present,
  'sitemap_url_count' => sitemap_urls.length,
  'sitemap_urls' => sitemap_urls,
  'remote_sitemap_status' => remote_sitemap_status,
  'remote_sitemap_error' => remote_sitemap_error,
  'pages_scanned' => html_files.length,
  'missing_canonicals' => missing_canonicals,
  'canonical_checks' => canonical_checks,
  'noindex_pages' => unique_noindex,
  'unexpected_noindex' => unexpected_noindex_list,
  'meta_refresh_pages' => refresh_pages,
  'lychee_report' => lychee_report,
  'warnings' => warnings,
  'counts' => counts,
  'items' => items
}

File.write(out_path, JSON.pretty_generate(results))
puts "SEO checks written to #{out_path}"

critical_missing_sitemap = counts[:missing_sitemap].positive? && !sitemap_optional
critical_violations = critical_missing_sitemap || counts[:non_200_canonicals].positive? || counts[:unexpected_noindex].positive?
warning_violations = counts[:warnings].positive? || counts[:missing_canonicals].positive?

exit_code =
  if critical_violations
    3
  elsif warning_violations
    soft_fail_warnings ? 0 : 2
  else
    0
  end

exit exit_code
