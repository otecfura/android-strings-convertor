require "nokogiri"
require "csv"
require "cgi"

arg = ARGV[0]
file =  File.open(ARGV[1])

def csvToXML(fileXML)
    language = ARGV[2]
    
    if language == nil
      puts "Specify language!"
      exit
    end

    results = File.read(fileXML)
    csv_table = CSV.parse(results, :headers => true)
    
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.resources{
         csv_table.entries.each do |csv_row|
          	xml.string "string", csv_row[language], :name => csv_row["name"] 
          end
      }
    end
    puts CGI::unescapeHTML(builder.to_xml)
end

if arg == "xml"
  str = ""
  xml_doc = Nokogiri::XML(file)
  array = xml_doc.xpath("//string")
	array.each do |xpath_node|
  	str.concat( "\"#{xpath_node.attribute('name')}\", \"#{xpath_node.text}\"\n")
  end
  puts str
end

if arg == "csv"
	csvToXML(file)
end