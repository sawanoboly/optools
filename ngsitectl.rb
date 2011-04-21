#!/usr/bin/env ruby
# encording: utf-8

## Const 
AvailDir = "/etc/nginx/sites-available/"
EnableDir = "/etc/nginx/sites-enabled/"


# list up all site and add "+" for enable sites.
def list(sitename)
  sitesall =  Dir.entries(AvailDir)

  # exclude dots
  sites = sitesall.select{|elem| elem != "." and elem !=".."}

  # enabled sites check.
  sites.each do |site|
    if File.exist?(EnableDir + site) then
      puts "+ " + site
    else
      puts "- " + site
      # File.symlink(AvailDir + site, EnableDir + site)
    end
  end
end

def enable(sitename)
  if File.exist?(EnableDir + sitename) then
    puts "Site:" + sitename + " is already enabled.\nDo nothing."
  elsif File.exist?(AvailDir + sitename) then
    puts "enable: " + sitename
    File.symlink(AvailDir + sitename, EnableDir + sitename)
    # puts `/etc/init.d/nginx reload`
    puts `nginx -t`
  else
    puts "Site:" + sitename + " Config not found."
  end
  list(sitename)
end

def disable(sitename)
  if File.exist?(AvailDir + sitename) then
    if File.exist?(EnableDir + sitename) then
      puts "disable: " + sitename
      File.unlink(EnableDir + sitename)
      # puts `/etc/init.d/nginx reload`
      puts `nginx -t`
    else
      puts "Site:" + sitename + " is already disabled.\nDo nothing."
    end
  else
    puts "Site:" + sitename + " Config not found."
  end
  list(sitename)
end


begin
  method(ARGV[0]).call(ARGV[1])
rescue TypeError => ex then
  puts <<"HEREDOCS"
  Nginx site control script.
  Usage:
    list: list all available sites
    enable {sitename}: enable site and configtest
    disable {sitename}: disable site and configtest
HEREDOCS
rescue => ex
  puts "Exception " + "#{ex.class}"
  puts "#{ex.message}"
  puts
  puts <<"HEREDOCS"
  Nginx site control script.
  Usage:
    list: list all available sites
    enable {sitename}: enable site and configtest
    disable {sitename}: disable site and configtest
HEREDOCS
end
