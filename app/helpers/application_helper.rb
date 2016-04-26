module ApplicationHelper
    def markdown(text)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :no_intra_emphasis => true, :autolink => true, :quote => true)
      return markdown.render(text).html_safe
    end
end
