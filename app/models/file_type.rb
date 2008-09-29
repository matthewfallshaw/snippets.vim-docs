class FileType
  @@vimdir = "~/.vim"

  class << self
    def all
      Dir[File.join(@@vimdir, "after/ftplugin/*_snippets.vim")].collect {|f| new(f) }
    end
  end

  def initialize(file)
    self.file = file
  end

  attr_accessor :file

  def name
    File.basename(file).sub(/_snippets.vim/, '')
  end
end
