guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  rspec = dsl.rspec
  watch(%r{^app/(.+).rb$}) do |m|
    "#{rspec.spec_dir}/#{m[1]}_spec.rb"
  end
  watch(rspec.spec_files)
end

guard :rubocop, all_on_start: false do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
end
