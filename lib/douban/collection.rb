require 'rexml/document'
require 'douban/subject'
module Douban
 class Collection
   class <<self
     def attr_names
       [
        :tag,
        :updated,
        :subject,
        :author,
        :title,
        :summary,
        :link,
        :id,
        :rating,
        :status
       ]
      end
    end
    attr_names.each do |attr|
      attr_accessor attr
    end
    def initialize(atom)
      doc=REXML::Document.new(atom)
      subject=REXML::XPath.first(doc,"//entry/db:subject")
      @subject=Subject.new(subject.to_s) if subject
      author=REXML::XPath.first(doc,"//entry/author")
      @author=Author.new(author.to_s) if author
      title=REXML::XPath.first(doc,"//entry/title")
      @title=title.text if !title.nil?
      updated=REXML::XPath.first(doc,"//entry/updated")
      @updated=updated.text if updated
      id=REXML::XPath.first(doc,"//entry/id")
      @id=id.text if id
      REXML::XPath.each(doc,"//entry/db:tag") do |tag|
        @tag||=[]
        @tag<<tag.attributes['name']
      end
      rating=REXML::XPath.first(doc,"//entry/db:rating")
     if rating
       @rating={}
       @rating['min']=rating.attributes['min']
       @rating['value']=rating.attributes['value']
       @rating['max']=rating.attributes['max']
     end
    end
 end
end
