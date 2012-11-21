require "net/http"
require "cgi"

require "iq_triplestorage"

class IqTriplestorage::SesameAdaptor < IqTriplestorage::BaseAdaptor

  def initialize(host, options={})
    super
    @repo = options[:repository]
    raise(ArgumentError, "repository must not be nil") if @repo.nil?
  end

  # expects a hash of N-Triples by graph URI
  def batch_update(triples_by_graph)
    path = "/repositories/#{CGI.escape(@repo)}/statements"
    path = URI.join("#{@host}/", path[1..-1]).path

    data = triples_by_graph.map do |graph_uri, ntriples|
      "<#{graph_uri}> {\n#{ntriples}\n}\n"
    end.join("\n\n")

    http_request("POST", path, data, { "Content-Type" => "application/x-trig" })
  end

end