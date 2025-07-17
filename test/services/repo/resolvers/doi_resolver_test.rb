require 'test_helper'

class Repo::Resolvers::DoiResolverTest < ActiveSupport::TestCase
  include LoggingCommonMock

  def setup
    @client = HttpClientMock.new(file_path: fixture_path('downloads/basic_http/sample_utf8.txt'), status_code:302, headers:{'location'=>'https://target'})
    @context = Repo::RepoResolverContext.new('doi:10.123/abc', http_client: @client)
    @resolver = Repo::Resolvers::DoiResolver.new(api_url: 'https://doi.org')
  end

  test 'priority is high' do
    assert_equal 99000, @resolver.priority
  end

  test 'resolve sets object_url on redirect' do
    @client = HttpClientMock.new(file_path: fixture_path('downloads/basic_http/sample_utf8.txt'), status_code:302, headers:{'location'=>'https://example.com'})
    @context = Repo::RepoResolverContext.new('doi:10.123/abc', http_client: @client)
    @resolver.resolve(@context)
    assert_equal 'https://example.com', @context.object_url
  end

  test 'resolve logs when cannot resolve' do
    http = HttpClientMock.new(file_path: fixture_path('downloads/basic_http/sample_utf8.txt'))
    @resolver = Repo::Resolvers::DoiResolver.new(api_url: 'https://doi.org')
    context = Repo::RepoResolverContext.new('doi:10.123/abc', http_client: http)
    @resolver.resolve(context)
    assert_nil context.object_url
  end
end
