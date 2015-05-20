#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module Plaby

  module EntryWriter

    def template
      File.readlines(File.join(TEMPLATE, DEFAULT_TEMPLATE, "post.haml")).join
    end

    def to_html
      tmp = Haml::Engine.new(template).render
      Mustache.render(tmp, self)
    end
  end

  module BlogLinkWriter

    def template
      File.readlines(File.join(TEMPLATE,DEFAULT_TEMPLATE, "bloglink.haml")).join
    end

    def to_html
      tmp = Haml::Engine.new(template).render
      Mustache.render(tmp,self)
    end
  end

  class Writer

    Template = File.join(TEMPLATE, DEFAULT_TEMPLATE, "plaby.haml")

    attr_reader :blogs


    def initialize(blogs)
      @blogs = blogs
    end

    def template
      @template ||= Haml::Engine.new(File.readlines(Template).join).render
    end

    def do_digest(n = 10)
      cnt = ""
      @blogs.posts.first(n).each do |post|
        cnt << write(post)
        cnt << "\n"
      end
      cnt
    end

    def do_blogs
      blog_html = "<aside><ul>"
      @blogs.each do |blog|
        blog_html << blog.extend(BlogLinkWriter).to_html
      end
      blog_html << "</ul></aside>"

    end

    def generate(rssposts_count = 10)

      cnt = do_digest(rssposts_count) 
      cnt <<  do_blogs
      newfile = template.gsub(/%%%%CONTENT%%%%/, cnt)

    end

    def write(post)
      post.extend(EntryWriter).to_html
    end
  end

end

=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end

