class FileUri
  attr_accessor :uri

  def initialize(uri = nil)
    @uri = unencode uri unless uri.nil?
  end

  def to_s
    unencode @uri.to_s
  end

  def filename
    unencode(path).match(/(?:.*\/)(.*)/)[1]
  end

  def filename_noext
    unencode(path).match(/(?:.*\/)(.*)(?:\.)/)[1]
  end

  def extension
    path.slice /[^.]*$/
  end

  def path
    @path ||= @uri.match(/(?:https?:\/\/.*(?:\.com))(.*)/)[1]
  end

  def key
    unencode(path).match(/^(?:\/)(.*)(?:\/)/)[1].match(/(?:\/)(.*)/)[1]
  end

  def bucket
    unencode(path).match(/\/(.*?)\//)[1]
  end

  def host
    @uri.match(/https?:\/\/.*(?:com)/)[0]
  end

  protected

    def unencode(source)
      source.gsub(/(%2F)|(\+)|(%23)|(%28)|(%29)|(%26)/,"%2F"=>'/',"+"=>" ","%23"=>"#","%28"=>"(","%29"=>")","%26"=>"&")
    end
end
