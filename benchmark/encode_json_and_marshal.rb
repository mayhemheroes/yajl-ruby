# encoding: UTF-8
require 'rubygems'
require 'benchmark'
require 'yajl_ext'
require 'json'

filename = ARGV[0] || 'benchmark/subjects/contacts.json'
json = File.new(filename, 'r')
hash = Yajl::Stream.parse(json)
json.close

times = ARGV[1] ? ARGV[1].to_i : 1
puts "Starting benchmark encoding #{filename} #{times} times\n\n"
Benchmark.bm { |x|
  x.report {
    puts "Yajl::Stream.encode"
    times.times {
      Yajl::Stream.encode(hash, StringIO.new)
    }
  }
  x.report {
    puts "JSON's #to_json"
    times.times {
      JSON.generate(hash)
    }
  }
  x.report {
    puts "Marshal.dump"
    times.times {
      Marshal.dump(hash)
    }
  }
}