require File.dirname(__FILE__) + '/test_helper.rb'
require 'oauth/request_proxy/typhoeus'
require 'typhoeus'
class TyphoeusRequestProxyTest < Test::Unit::TestCase

  def test_that_proxy_simple_get_request_works
    request = ::Typhoeus::Request.new('/test?key=value')
    request_proxy = OAuth::RequestProxy.proxy(request, {:uri => 'http://example.com/test?key=value'})

    expected_parameters = {'key' => ['value']}
    assert_equal expected_parameters, request_proxy.parameters_for_signature
    assert_equal 'http://example.com/test', request_proxy.normalized_uri
    assert_equal 'GET', request_proxy.method
  end

  def test_that_proxy_simple_post_request_works_with_arguments
    request = Typhoeus::Request.new('/test', :method => :post)
    params = {'key' => 'value'}
    request_proxy = OAuth::RequestProxy.proxy(request, {:uri => 'http://example.com/test', :parameters => params})

    expected_parameters = {'key' => 'value'}
    assert_equal expected_parameters, request_proxy.parameters_for_signature
    assert_equal 'http://example.com/test', request_proxy.normalized_uri
    assert_equal 'POST', request_proxy.method
  end

  def test_that_proxy_simple_post_request_works_with_form_data
    request = Typhoeus::Request.new('/test', :method => :post,
      :body => {'key' => 'value'},
      :headers => {'Content-Type' => 'application/x-www-form-urlencoded'})
    request_proxy = OAuth::RequestProxy.proxy(request, {:uri => 'http://example.com/test'})

    expected_parameters = {'key' => 'value'}
    assert_equal expected_parameters, request_proxy.parameters_for_signature
    assert_equal 'http://example.com/test', request_proxy.normalized_uri
    assert_equal 'POST', request_proxy.method
  end

  def test_that_proxy_simple_put_request_works_with_arguments
    request = Typhoeus::Request.new('/test', :method => :put)
    params = {'key' => 'value'}
    request_proxy = OAuth::RequestProxy.proxy(request, {:uri => 'http://example.com/test', :parameters => params})

    expected_parameters = {'key' => 'value'}
    assert_equal expected_parameters, request_proxy.parameters_for_signature
    assert_equal 'http://example.com/test', request_proxy.normalized_uri
    assert_equal 'PUT', request_proxy.method
  end

  def test_that_proxy_simple_put_request_works_with_form_data
    request = Typhoeus::Request.new('/test', :method => :put, :body => {'key' => 'value'})
    request_proxy = OAuth::RequestProxy.proxy(request, {:uri => 'http://example.com/test'})

    expected_parameters = {}
    assert_equal expected_parameters, request_proxy.parameters_for_signature
    assert_equal 'http://example.com/test', request_proxy.normalized_uri
    assert_equal 'PUT', request_proxy.method
  end

  def test_that_proxy_post_request_works_with_mixed_parameter_sources
    request = Typhoeus::Request.new('/test?key=value', 
      :method => :post,
      :body => {'key2' => 'value2'},
      :headers => {'Content-Type' => 'application/x-www-form-urlencoded'})
    request_proxy = OAuth::RequestProxy.proxy(request, {:uri => 'http://example.com/test?key=value', :parameters => {'key3' => 'value3'}})

    expected_parameters = {'key' => ['value'], 'key2' => 'value2', 'key3' => 'value3'}
    assert_equal expected_parameters, request_proxy.parameters_for_signature
    assert_equal 'http://example.com/test', request_proxy.normalized_uri
    assert_equal 'POST', request_proxy.method
  end
end
