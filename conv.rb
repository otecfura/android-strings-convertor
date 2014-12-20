require "nokogiri"
require "csv"
require "cgi"

file =  File.open(ARGV[0])
$language = ARGV[1]

if $language == nil
  puts "Specify language!"
  exit
end

def self.escape_characters_in_string(string)
  pattern = /(\'|\")/
  string.gsub(pattern){|match|"\\"  + match}
end

def csvToXML(fileXML)
    results = File.read(fileXML)
    csv_table = CSV.parse(results, :headers => true)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.resources{
         csv_table.entries.each do |csv_row|
          	xml.string "string", escape_characters_in_string(csv_row[$language]), :name => csv_row["name"] 
          end
      }
    end
    puts CGI::unescapeHTML(builder.to_xml)
end

def xmlToCSV(fileXML)
  str = ""
  xml_doc = Nokogiri::XML(fileXML)
  array = xml_doc.xpath("//string")
  str.concat("\"name\", \"#{$language}\"\n")
  array.each do |xpath_node|
  str.concat( "\"#{xpath_node.attribute('name')}\", \"#{xpath_node.text}\"\n")
  end
  puts str
end

if File.extname(file).downcase == ".xml"
  xmlToCSV(file)
end

if File.extname(file).downcase == ".csv"
	csvToXML(file)
end