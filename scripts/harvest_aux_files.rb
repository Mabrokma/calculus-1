#!/usr/bin/ruby

# The purpose of this script is to save the information in the aux files so we don't have
# to run pdftex three times every time we want to make html output. It collects all the
# aux files, parses them, and saves them in save.ref .
# I also use this in eruby_util.rb for a workaround for a bug in latex that sometimes
# makes it impossible to use a pageref ("Missing \endcsname inserted").

files = Dir["*/*.aux"]
files = files.concat(Dir["*.aux"])

if files.empty? then
  $stderr.print "Error, no aux files found\n"
  exit(-1)
end

verbose = false

File.open('save.ref','w') do |g|
  $stderr.print "Harvesting " if verbose
  files.each {|aux|
    File.open(aux,'r') do |f|
      t = f.gets(nil) # nil means read whole file
      $stderr.print "#{aux} " if verbose

      # lines look like this:  \newlabel{fig:comet-goofy-orbit}{{a}{14}}

      t.scan(/\\newlabel{([^}]+)}{{([^}]*)}{([^}]+)}}/) { |label,number,page|
        #$stderr.print "label=#{label}, #{number}, p. #{page}\n"
        g.print "#{label},#{number},#{page}\n"
      }
    end
  }
  $stderr.print "\n" if verbose
end
