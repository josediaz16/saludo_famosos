require 'shrine'

case Jets.env
when "development"
  puts "hola mundo"
  require 'shrine/storage/file_system'
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
  }
when "test"
  require 'shrine/storage/memory'
  Shrine.storages = { 
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new,
  }
when "production"
  "damn"
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :data_uri
