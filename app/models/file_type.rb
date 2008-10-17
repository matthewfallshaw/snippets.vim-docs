class FileType
  @@vimdir = "~/.vim"

  class << self
    def all
      Dir[snippets_files].collect {|f| new(f) }
    end

  private

    def snippets_files
      File.expand_path(File.join(@@vimdir, "after/ftplugin/*_snippets.vim"))
    end
  end

  def initialize(file)
    self.file = file
  end

  attr_accessor :file

  def name
    File.basename(file).sub(/_snippets.vim/, '')
  end

  def snippets
    snippets = []
    File.open(file) do |f|
      f.each do |line|
        subs = {}
        case line
        when /let (..) = g:(\w+)/
          subs[$1] = $2
        when /exec ([^ ]*)/
          snippets << Snippet.new($1, subs)
        else
          # not interesting
        end
      end
    end
    snippets
  end
end
