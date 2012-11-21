require File.join(File.expand_path(File.dirname(__FILE__)), "test_helper")

require "base64"

require "iq_triplestorage/sesame_adaptor"

class SesameTest < WebTestCase

  def setup
    super
    WebMock.stub_request(:any, /.*example.org.*/).with(&@request_handler).
        to_return do |req|
          { :status => req.uri.to_s.end_with?("/rdf_sink") ? 200 : 201 }
        end

    @host = "http://example.org/sesame"
    @repo = "test"
    @username = "foo"
    @password = "bar"

    @adaptor = IqTriplestorage::SesameAdaptor.new(@host, :repository => @repo,
        :username => @username, :password => @password)
  end

  def test_batch
    data = {
      "http://example.com/foo" => "<aaa> <bbb> <ccc> .\n<ddd> <eee> <fff> .",
      "http://example.com/bar" => "<ggg> <hhh> <iii> .\n<jjj> <kkk> <lll> ."
    }

    @observers << lambda do |req|
      assert_equal :post, req.method
      path = req.uri.path
      assert path.
          start_with?("/sesame/repositories/#{CGI.escape(@repo)}/statements")
      assert_equal "application/x-trig", req.headers["Content-Type"]
      data.each do |graph_uri, ntriples|
        assert req.body.include?(<<-EOS)
<#{graph_uri}> {
#{ntriples}
}
        EOS
      end
    end
    assert @adaptor.batch_update(data)
  end

end