module Knox
  VERSION = File.read(
    File.expand_path(
      File.join(
        File.dirname(__FILE__),
        '../..',
        'VERSION'
      )
    )
  ).freeze
end
